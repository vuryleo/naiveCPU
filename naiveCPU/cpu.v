module cpu (
  input clk, rst,
  output [15:0] Aaddr, Baddr,
  output [15:0] dataWrtie,
  output [1:0] MeMemControl,
  input [15:0] AmemRead, BmemRead,
  output [175:0] registerValue,
  output [15:0] IfPC, IfIR,
  output [15:0] instructionTemp,
  output [3:0] registerS, registerM, IdRegisterT, MeRegisterT,
  output [15:0] ExCalResult, MeCalResult
);

wire [15:0] nextPC;//, IdIR;
wire [15:0] rs, rm;
//wire [3:0] registerS, registerM;
wire [1:0] IdMemControl, ExMemControl;
wire [3:0] /*IdRegisterT,*/ ExRegisterT;//, MeRegisterT;//, WbRegisterT;
//wire [15:0] MeCalResult;

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
  instructionTemp,
  registerS, registerM, IdRegisterT,
  IdMemControl
);

forwarder IdIRforward (
  clk, rst,
  IfIR,
  IdIR
);

forwarder2bit ExMemControlforward (
  clk, rst,
  IdMemControl,
  ExMemControl
);

forwarder2bit MeMemControlforward (
  clk, rst,
  ExMemControl,
  MeMemControl
);

forwarder4bit ExRegisterTforward (
  clk, rst,
  IdRegisterT,
  ExRegisterT
);

forwarder4bit MeRegisterTforward (
  clk, rst,
  ExRegisterT,
  MeRegisterT
);

forwarder MeCalResultforward (
  clk, rst,
  ExCalResult,
  MeCalResult
);

alu calculator (
  clk, rst,
  rs, rm,
  IfPC, IdIR,
  ExCalResult
);

Register registerFile (
  clk, rst,
  registerS, registerM,
  1, 0,
  MeRegisterT,
  MeCalResult,
  registerValue,
  rs, rm
);

endmodule

