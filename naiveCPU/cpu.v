module cpu (
  input clk, rst,
  output [15:0] Aaddr, Baddr,
  output [15:0] dataWrtie,
  output [1:0] rw,
  input [15:0] AmemRead, BmemRead,
  output [175:0] registers,
  output [15:0] IfPC, IfIR
);

wire [15:0] nextPC;

//assign IfPC = 16'hFFFF;
//assign IfIR = 16'hEEEE;

PCregister pc (
  clk, rst,
  nextPC,
  IfPC
);

PCadder pcAdder (
  clk, rst,
  IfPC,
  nextPC
);

instructionReader reader (
  clk,
  IfPC,
  BmemRead,
  Baddr,
  IfIR
);

//IFIDregister IFIDr (
//  IfIR,
//  IdIR,
//  IfPC,
//  IdPC
//);

Register registerFile (
  clk, rst,
  0, 0, 0,
  1, 0,
  1, 0,
  0,
  registers
);

endmodule

