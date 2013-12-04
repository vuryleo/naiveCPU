#!/usr/bin/python2
# -*- coding: utf-8 -*-
# $File: ppm2v.py
# $Date: Sun Nov 03 11:27:11 2013 +0800
# $Author: Xinyu Zhou <zxytim[at]gmail[dot]com>

# ppm P3

import copy
import argparse
import math
import sys
from collections import defaultdict

def read_ppm(fname):
    img = []
    with open(fname) as f:
        p3 = f.readline().rstrip()
        width, height = map(int, f.readline().rstrip().split())
        maxv = float(f.readline().rstrip())
        tmp = []
        for line in f.readlines():
            tmp.extend(map(int, line.rstrip().split()))

        assert len(tmp) == width * height * 3
        i = 0
        for x in xrange(height):
            line = []
            for y in xrange(width):
                line.append((tmp[i] / maxv, tmp[i + 1] / maxv, \
                        tmp[i + 2] / maxv))
                i += 3
            img.append(line)
    return img

# return width, height
def size(img):
    return len(img[0]), len(img)

def segment(img, num_color):
    palette = {
        2: [0, 7],
        3: [0, 4, 7],
        4: [0, 2, 5, 7],
        5: [0, 2, 4, 5, 7],
        6: [0, 2, 3, 4, 5, 7],
        7: [0, 2, 3, 4, 5, 6, 7],
        8: [0, 1, 2, 3, 4, 5, 6, 7]}
    ret = []
    w, h = size(img)
    for x in xrange(h):
        line = []
        for y in xrange(w):
            line.append(tuple(map(lambda x: palette[num_color][int(min(num_color - 1, \
                    math.floor(x * num_color)))], img[x][y])))
        ret.append(line)
    return ret

def trim(img_):
    img = copy.deepcopy(img_)
    w, h = size(img)
    valid_set = set()
    coords = []
    for x in xrange(h):
        for y in xrange(w):
            coords.append((x, y))
    for x, y in coords:
        valid_set.add((x, y))
    ret = []
    for x, y in coords:
        if (x, y) not in valid_set:
            continue
        valid_set.remove((x, y))
        lx, ly = 1, 1
        while True:
            expanded = False
            # expand y
            flag = True
            for dx in xrange(lx):
                if not ((x + dx, y + ly) in valid_set and img[x][y] == img[x + dx][y + ly]):
                    flag = False
                    break
            if flag:
                for dx in xrange(lx):
                    valid_set.remove((x + dx, y + ly))
                ly += 1
                expanded = True

            # expand x
            flag = True
            for dy in xrange(ly):
                if not ((x + lx, y + dy) in valid_set and img[x][y] == img[x + lx][y + dy]):
                    flag = False
                    break
            if flag:
                for dy in xrange(ly):
                    valid_set.remove((x + lx, y + dy))
                lx += 1
                expanded = True

            if not expanded:
                break

#        while (x, y + t) in valid_set and img[x][y] == img[x][y + t]:
#            valid_set.remove((x, y + t))
#            t += 1
        ret.append((x, y, lx, ly, img[x][y]))
    return ret

def get_cond(tup):
    x, y, lx, ly, c = tup
    if ly == 1:
        xcond = "pixel_x == {}" . format(y)
    else:
        xcond = "pixel_x >= {} && pixel_x < {}" . format(y, y + ly)
    if lx == 1:
        ycond = "pixel_y == {}" . format(x)
    else:
        ycond = "pixel_y >= {} && pixel_y < {}" . format(x, x + lx)

    return "(" + xcond + " && " + ycond + ")"

def get_color_code(col):
    ret = "9'b"
    for c in col:
        assert c >= 0 and c < 8
        ret += str(c / 4) + str(c / 2 % 2) + str(c % 2)
    return ret

def get_args():
    description = "convert a ppm file to verilog code for vga_driver."
    parser = argparse.ArgumentParser(description = description)

    parser.add_argument('-i', '--input', required = True,
            help = 'input ppm file')
    parser.add_argument('-o', '--output',
            help = 'output verilog file. if not specified, print to stdout.',
            default = '')
    parser.add_argument('-c', '--num-color',
            default = 2, type = int, choices = range(2, 8),
            help = 'number of colors to use. the more the color, the larger the output will be')

    args = parser.parse_args()

    return args


def main():
    args = get_args()

    img = read_ppm(args.input)
    img = segment(img, args.num_color)
    tuples = trim(img)

    groupbycolor = defaultdict(list)
    for tup in tuples:
        groupbycolor[tup[-1]].append(tup)

    gbc_tups = sorted( groupbycolor.iteritems(), key = lambda x: len(x[1]))

    if len(args.output) == 0:
        fout = sys.stdout
    else: fout = open(args.output, 'w')

    for ind, (col, tups) in enumerate(gbc_tups[:-1]):
        if ind == 0:
            prefix = 'if'
        else: prefix = 'else if'
        conds = "(" + " || " . join(map(get_cond, tups)) + ")"
        action = "    color_out <= {};" . format(get_color_code(col))
        fout.write(prefix + conds + "\n")
        fout.write(action + "\n")
    fout.write(("else color_out <= {};" .  format(
        get_color_code(gbc_tups[-1][0]))) + "\n")
    args.close_output_fd()
    if fout != sys.stdout:
        fout.close()

if __name__ == '__main__':
    main()

# vim: foldmethod=marker
