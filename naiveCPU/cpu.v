module cpu (
  input clk, rst,
  output [15:0] Aaddr, Baddr,
  output [15:0] dataWrtie,
  output [1:0] rw,
  input [15:0] AmemRead, BmemRead,
  output [175:0] registerValue,
  output [15:0] IfPC, IfIR,
  output [3:0] registerS, registerM, registerT,
  output [15:0] calResult
);

wire [15:0] nextPC, IdIR;
wire rs, rm;

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

instructionDecoder decoder (
  clk, rst,
  IfIR,
  registerS, registerM, registerT
);

forwarder IdIRforward (
  clk, rst,
  IfIR,
  IdIR
);

alu calculator (
  clk, rst,
  rs, rm,
  IfPC, IdIR,
  calResult
);

Register registerFile (
  clk, rst,
  registerS, registerM,
  1, 0,
  registerT,
  0,
  registerValue
);

endmodule

