module cpu (
  input clk, rst,
  output [15:0] Aaddr, Baddr,
  output [15:0] ExCalResult,
  output [1:0] ExMemControl,
  input [15:0] AmemRead, BmemRead,
  output [175:0] registerValue,
  output [15:0] IfPC, IfIR,
  output [15:0] instructionTemp,
  output [3:0] registerS, registerM, IdRegisterT, MeRegisterT,
  output [15:0] MeCalResult
);

wire [15:0] nextPC, IdIR;
wire [15:0] rs, rm;
//wire [3:0] registerS, registerM;
wire [1:0] /*ExMemControl, */ MeMemControl;
wire [15:0] originValueS, originValueM;
wire [15:0] sourceValueS, sourceValueM;
wire [3:0] /*IdRegisterT,*/ ExRegisterT;//, MeRegisterT;//, WbRegisterT;
//wire [15:0] MeCalResult;

//assign IfPC = 16'hFFFF;
//assign IfIR = 16'hEEEE;

reg [15:0] AmemReadTemp;

always @ (posedge clk or negedge rst)
  if (!rst)
    AmemReadTemp = 0;
  else
    AmemReadTemp = AmemRead;


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
  registerS, registerM, IdRegisterT
);

forwarder IdIRforward (
  clk, rst,
  IfIR,
  IdIR
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
  IfPC, IdIR,
  ExCalResult
);

memAddressCalculator addrCalculator(
  clk, rst,
  IdIR,
  rm,
  ExMemControl,
  Aaddr
);

meCalResultSelector MeCalResultMux (
  MeMemControl,
  AmemReadTemp,
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
  1, 0,
  MeRegisterT,
  MeCalResult,
  registerValue,
  originValueS, originValueM
);

endmodule

