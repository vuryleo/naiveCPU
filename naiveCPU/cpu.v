module cpu (
  input clk, rst,
  output [15:0] MeAaddr, Baddr,
  output [15:0] ExCalResult,
  output [15:0] MeMemResult,
  output [1:0] MeMemControl,
  input [15:0] AmemRead, BmemRead,
  input hardwareInterruptSignal,
  input [3:0] hardwareInterruptIndex,
  // vga debug signals
  output [175:0] registerValue,
  output [15:0] nextPC, IfIR,
  output [3:0] registerS, registerM, IdRegisterT, MeRegisterT,
  output [15:0] MeCalResult,
  output [15:0] interruptPC, interruptIR
);

wire [15:0] IfPC, IdIR, IdPC;
wire interruptSignal, interruptOccurs, eret;
wire [3:0] interruptIndex;
wire softwareInterruptSignal, IfSoftwareInterruptSignal;
wire [3:0] softwareInterruptIndex, IfSoftwareInterruptIndex;
//wire [15:0] interruptPC;
wire [15:0] normalNextPC;
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
wire [15:0] /*interruptIR,*/ readIfIR;

//assign returnIROut = returnIR;

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
  interruptOccurs,
  interruptPC,
  normalNextPC,
  nextPC
);

interrupt interruptM (
  clk, rst,
  normalNextPC, readIfIR,
  interruptSignal,
  interruptIndex,
  eret,
  interruptOccurs,
  interruptPC,
  interruptIR
);

selector InterruptIRSelector (
  eret & interruptOccurs,
  interruptIR,
  readIfIR,
  IfIR
);

instructionReader reader (
  clk, rst,
  nextPC,
  BmemRead,
  Baddr,
  readIfIR
);

interruptArbitration arbitration (
  hardwareInterruptSignal,
  hardwareInterruptIndex,
  softwareInterruptSignal,
  softwareInterruptIndex,
  interruptSignal,
  interruptIndex
);

instructionDecoder decoder (
  clk, rst,
  IfIR,
  registerS, registerM, IdRegisterT,
  jumpControl,
  IfSoftwareInterruptSignal,
  IfSoftwareInterruptIndex,
  eret
);

forwarder1bit softwareInterruptSignalforward (
  clk, rst,
  IfSoftwareInterruptSignal,
  softwareInterruptSignal
);

forwarder4bit IfsoftwareInterruptIndexforward (
  clk, rst,
  IfSoftwareInterruptIndex,
  softwareInterruptIndex
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

