naiveCPU
========
Implemented by

* ppwwyyxx (ppwwyyxxc@gmail.com)
* Ray Song (emacsray@gmail.com)
* Vury Leo (i@vuryleo.com)

This is a TCHO-MIPS 16bits CPU that assigned as homework of Computer Compose Principle.

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
FF00 ~ FFFF BIOS

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

