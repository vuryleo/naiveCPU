module cpu (
  input clk, rst,
  output [15:0] Aaddr, Baddr,
  output [15:0] dataWrtie,
  output [1:0] MeMemControl,
  input [15:0] AmemRead, BmemRead,
  output [175:0] registerValue,
  output [15:0] IfPC, IfIR,
  output [15:0] calResult
);

wire [15:0] nextPC, IdIR;
wire [15:0] rs, rm;
wire [1:0] IdMemControl, ExMemControl;
wire [3:0] IdRegisterT, ExRegisterT, MeRegisterT, WbRegisterT;

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
  clk, rst,
  IfPC,
  BmemRead,
  Baddr,
  IfIR
);

instructionDecoder decoder (
  clk, rst,
  IfIR,
  registerS, registerM, IdRegisterT,
  IdMemControl
);

forwarder IdIRforward (
  clk,
  IfIR,
  IdIR
);

forwarder2bit ExMemControlforward (
  clk,
  IdMemControl,
  ExMemControl
);

forwarder2bit MeMemControlforward (
  clk,
  ExMemControl,
  MeMemControl
);

forwarder4bit ExRegisterTforward (
  clk,
  IdRegisterT,
  ExRegisterT
);

forwarder4bit MeRegisterTforward (
  clk,
  ExRegisterT,
  MeRegisterT
);

forwarder4bit WbRegisterTforward (
  clk,
  MeRegisterT,
  WbRegisterT
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
  WbRegisterT,
  calResult,
  registerValue,
  rs, rm
);

endmodule

