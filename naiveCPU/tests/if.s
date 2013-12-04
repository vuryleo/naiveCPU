.if r2 < r0
  sltui r1 4
  .if r3 >= r5
    cmpi r3 4
  .else
    cmpi r5 8
  .end
.else
  sltui r1 5
.end
.if r2 > 1
  sltui r1 4
.end
.if r2 <= 2
  sltui r1 4
.end
.if r2 >= 3
  sltui r1 4
.end
