li r1 1
li r2 1
li r3 4
sll r3 r3 0
li r4 19
back: sw r3 r1 0
sw r3 r2 2
addu r1 r2 r1
addu r1 r2 r2
addiu r3 4
addiu r4 ff
bnez r4 back
nop
circle: b circle
nop
