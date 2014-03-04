naiveCPU
========
This is a THCO-MIPS 16bits CPU implemented in Verilog, served as the course project in *Computer Organization (2013Fall)* in Tsinghua University.

Authors:

* ppwwyyxx (ppwwyyxxc@gmail.com)
* Ray Song (emacsray@gmail.com)
* Vury Leo (i@vuryleo.com)

Protocols
=========

Boot
----
On reset process, the PC register will be set to FF00, where it BIOS located.

Registers
---------
R0 ~ R7 ==> "0000" ~ "0111"
IH ==> "1000"
SP ==> "1001"
RA ==> "1010"

Memory Mapping
--------------
0000 ~ 7FFF physical memory, so only 31KB of memory is available
F000 ~ FDFF graphic memory
FE00 keyboard input
FF00 ~ FFFF rom

VGA
---
On debug mode, VGA will display the status of CPU as a supervising program for convenient debuging.
The left part will be the registers storage, the right part will be the result cache of each step.
So, developers will spot which part was going wrong very easily.
Though it spend lots of compiling time and lots of logic gate, it is effective in most situations.

Interrupt
---------
In order to support hardware interrupt, an extra instruction is introduced.
It is called `eret`. And its binary format is `1000000000000000`, and hexadecimal format is `8000`.
When executing this instruction, CPU will clear the interrupt signal and reset PC to EPC that stored when interrupt occers.

*Notice* `eret` instruction is a jump instruction, so a delay slot is required.

naiveKernel
===========
naiveKernel is a basic OS kernel that implements serval system calls, and is embedded a text editor and a interpreter.

Memory
------
0000 ~ 0003 boot instruction *Just a b instruction that point to real program*
0004 ~ 003f interrupt vector table
0200 stack bottom
0400 I/O buffer start

Interrupts
----------
0 -> reserved
1 -> load keyboard input into I/O buffer
2 -> read I/O buffer
3 -> write to graphic memory

For interrupts' detail, please refer to wiki.
