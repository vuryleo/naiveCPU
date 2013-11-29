module cpu (
  input clk, rst,
  output [15:0] Aaddr, Baddr,
  output [15:0] ExCalResult,
  output [1:0] ExMemControl,
  input [15:0] AmemRead, BmemRead,
  output [175:0] registerValue,
  output [15:0] nextPC, IfIR,
  output [3:0] registerS, registerM, IdRegisterT, MeRegisterT,
  output [15:0] MeCalResult,
  output [15:0] originValueS
);

wire [15:0] IfPC, IdIR, IdPC;
wire [15:0] rs, rm;
wire t;
wire tWriteEnable, tToWrite;
wire [2:0] jumpControl;
//wire [3:0] registerS, registerM;
wire [1:0] /*ExMemControl, */ MeMemControl;
wire [15:0] /*originValueS,*/ originValueM;
wire [15:0] sourceValueS, sourceValueM;
wire [3:0] /*IdRegisterT,*/ ExRegisterT;//, MeRegisterT;
//wire [15:0] MeCalResult;

//assign IfPC = 16'hFFFF;
//assign IfIR = 16'hEEEE;

//reg [15:0] AmemReadTemp;

//always @ (posedge clk or negedge rst)
//  if (!rst)
//    AmemReadTemp = 0;
//  else
//    AmemReadTemp = AmemRead;

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
  instructionTemp,
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

alu calculator (
  clk, rst,
  rs, rm,
  IdPC, IdIR,
  ExCalResult,
  tWriteEnable, tToWrite
);

memAddressCalculator addrCalculator(
  clk, rst,
  IdIR,
  rm,
  ExMemControl,
  Aaddr
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

