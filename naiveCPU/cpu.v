module cpu (
  input clk, rst,
  output [15:0] MeAaddr, Baddr,
  output [15:0] ExCalResult,
  output [15:0] MeMemResult,
  output [1:0] MeMemControl,
  input [15:0] AmemRead, BmemRead,
  // vga debug signals
  output [175:0] registerValue,
  output [15:0] nextPC, IfIR,
  output [3:0] registerS, registerM, IdRegisterT, MeRegisterT,
  output [15:0] MeCalResult
);

wire [15:0] IfPC, IdIR, IdPC;
wire [15:0] rs, rm;
wire t;
wire tWriteEnable, tToWrite;
wire [2:0] jumpControl;
//wire [3:0] registerS, registerM;
wire [1:0] ExMemControl/*, MeMemControl*/;
wire [15:0] originValueS, originValueM;
wire [15:0] sourceValueS, sourceValueM;
wire [3:0] /*IdRegisterT,*/ ExRegisterT;//, MeRegisterT;
//wire [15:0] MeCalResult;
wire [15:0] ExAaddr/*, MeAaddr, MeMemResult*/;

PCadder pcAdder (
  clk, rst,
  nextPC,
  IfIR,
  rs,
  t,
  jumpControl,
  nextPC
);

instructionReader reader (
  clk, rst,
  nextPC,
  BmemRead,
  Baddr,
  IfIR
);

instructionDecoder decoder (
  clk, rst,
  IfIR,
  registerS, registerM, IdRegisterT,
  jumpControl
);

forwarder IfPCforward (
  clk, rst,
  nextPC,
  IfPC
);

forwarder IdIRforward (
  clk, rst,
  IfIR,
  IdIR
);

forwarder IdPCforward (
  clk, rst,
  IfPC,
  IdPC
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

//forwarder MeCalResultforward (
//  clk, rst,
//  ExCalResult,
//  MeCalResult
//);

forwarder2bit MeMemControlforward (
  clk, rst,
  ExMemControl,
  MeMemControl
);

forwarder MeMemResultforward (
  clk, rst,
  ExCalResult,
  MeMemResult
);

forwarder MeAaddrResultforward (
  clk, rst,
  ExAaddr,
  MeAaddr
);

alu calculator (
  clk, rst,
  rs, rm,
  IfPC, IdIR,
  ExCalResult,
  tWriteEnable, tToWrite
);

memAddressCalculator addrCalculator(
  clk, rst,
  IdIR,
  rm,
  ExMemControl,
  ExAaddr
);

meCalResultSelector MeCalResultMux (
  clk, rst,
  MeMemControl,
  AmemRead,
  ExCalResult,
  MeCalResult
);

byPass MeIdByPassS (
  registerS,
  originValueS,
  MeRegisterT,
  MeCalResult,
  sourceValueS
);

byPass MeIdByPassM (
  registerM,
  originValueM,
  MeRegisterT,
  MeCalResult,
  sourceValueM
);

byPass ExIdByPassS (
  registerS,
  sourceValueS,
  ExRegisterT,
  ExCalResult,
  rs
);

byPass ExIdByPassM (
  registerM,
  sourceValueM,
  ExRegisterT,
  ExCalResult,
  rm
);

Register registerFile (
  clk, rst,
  registerS, registerM,
  tWriteEnable, tToWrite,
  MeRegisterT,
  MeCalResult,
  registerValue,
  originValueS, originValueM,
  t
);

endmodule

