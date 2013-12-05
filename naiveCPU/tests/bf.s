# beginning of programs: 2000
	li r6 20
	sll r6 r6 0

# beginning of cells: 6000
	li r7 60
	sll r7 r7 0

main_loop:
	lw r5 r6 0                            # r5 = pos
	lw r4 r7 0                            # r4 = cell[pos]
	li r2 0                               # row of next character
	li r3 0                               # column of next character
	.if r5 == '+'
		addiu r4 1
		sw r7 r4 0
	.elif r5 == '-'
		addiu r4 -1
		sw r7 r4 0
	.elif r5 == '<'
		addiu r7 -1
	.elif r5 == '>'
		addiu r7 1
	.elif r5 == '.'
		move r1 r4
		int 3
		addiu r3 1
		.if r3 == 64
			addiu r2 1
			li r3 0
		.end
	.elif r5 == ','
		# TODO
	.elif r5 == '['
		.if r4 == 0
			xor r3 r3             # number of unmatched parentheses
lparen_loop:
			lw r4 r7 0
			.if r4 == '['
				addiu r3 1
			.elif r4 == ']'
				addiu r3 -1
			.end
			addiu r7 1
			bnez r3 @lparen_loop
		.end
	.elif r5 == ']'
		.if r4 != 0
			xor r3 r3
rparen_loop:
			lw r4 r7 0
			.if r4 == '['
				addiu r3 1
			.elif r4 == ']'
				addiu r3 -1
			.end
			bnez r7 @rparen_loop
			addiu r3 -1
		.end
	.else
		b @exit
		nop
	.end
	b @main_loop
exit:
	nop
