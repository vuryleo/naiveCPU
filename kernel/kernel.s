b init
nop
b keyboard
nop
b readbuf
nop
b print
nop

init:
li r1 02
sll r1 r1 0
mtsp r1
li r1 04
sll r1 r1 0
addiu3 r1 r2 4
sw r1 r2 0
sw r1 r2 2
b textedit
nop
circle: b circle
nop

keyboard:
sw_sp r1 0
sw_sp r2 2
sw_sp r3 4
li r1 fe
sll r1 r1 0
lw r1 r3 0
li r1 04
sll r1 r1 0
lw r1 r2 2
nop
sw r2 r3 0
addiu r2 2
sw r1 r2 2
lw_sp r3 4
lw_sp r2 2
lw_sp r1 0
eret
nop

readbuf:
sw_sp r3 0
li r1 04
sll r1 r1 0
lw r1 r2 0
lw r1 r3 2
nop
cmp r2 r3
bteqz readbuf_null
addiu3 r2 r3 2
sw r1 r3 0
lw r2 r1 0
li r2 0
readbuf_return:
lw_sp r3 0
eret
nop

readbuf_null:
li r2 1
b readbuf_return
nop

print:
sw_sp r4 0
li r4 f0
sll r4 r4 0
sll r2 r2 7
sll r3 r3 1
addu r2 r4 r4
addu r3 r4 r4
sw r4 r1 0
lw_sp r4 0
eret
nop

textedit:
li r4 0f
sll r4 r4 0
li r5 0
li r6 0
readchar:int 2
nop
bnez r2 readchar
nop
move r3 r5
sll r3 r3 6
addu r6 r3 r3
sll r3 r3 1
addu r4 r3 r3
sw r3 r1 0
move r2 r5
move r3 r6
int 3
cmpi r6 3f
btnez skipswitchline
addiu3 r6 r6 1
li r6 0
addiu3 r5 r5 1
skipswitchline:
b readchar
nop

