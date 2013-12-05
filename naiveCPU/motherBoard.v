module motherBoard (
  input clk, rst, clkHand,
  inout [15:0] memDataBus,
  output [17:0] memAddrBus,
  output memRead, memWrite, memEnable,
  input keyDown,
  input [15:0] inputValue,
  output vgaHs, vgaVs,
  output [2:0] vgaR, vgaG, vgaB,
  output [15:0] leddebug
);

wire [175:0] registerValue;
wire [13:0] actualGraphicMemory;
wire [15:0] memAaddr, memBaddr, memAdataRead, memBdataRead, MeMemResult;
wire [1:0] memRW;
wire [15:0] physicalMemAaddr, physicalMemBaddr;
wire [15:0] ramAdataRead, ramBdataRead, romAdataRead, romBdataRead;
wire [15:0] IfPC, IfIR;
wire [15:0] ExCalResult, MeCalResult;
wire hardwareInterruptSignal;
wire [3:0] hardwareInterruptIndex;
wire [15:0] keyboardData;
wire [15:0] interruptPC, interruptIR;
wire [7:0] renderAscii;
wire [13:0] renderIndex;

wire [3:0] registerS, registerM, IdRegisterT, MeRegisterT;

reg clk25M, clk12M;

always @ (negedge clk, negedge rst)
begin
  if (!rst)
    clk25M = 0;
  else
    clk25M = ~ clk25M;
end

always @ (negedge clk25M or negedge rst)
  if (!rst)
    clk12M = 0;
  else
    clk12M = ~ clk12M;

assign leddebug = {memRW};

cpu naive (
  clkHand, rst,
  memAaddr, memBaddr,
  ExCalResult, MeMemResult, memRW,
  memAdataRead, memBdataRead,
  hardwareInterruptSignal, hardwareInterruptIndex,
  registerValue,
  IfPC, IfIR,
  registerS, registerM, IdRegisterT, MeRegisterT,
  MeCalResult,
  interruptPC, interruptIR
);

GraphicCard graphic (
  clk25M, rst,
  registerValue,
  IfPC, IfIR,
  registerS, registerM, IdRegisterT, MeRegisterT,
  ExCalResult, MeCalResult,
  vgaHs, vgaVs,
  vgaR, vgaG, vgaB,
  renderAscii,
  renderIndex
);

memoryMapping mapingA (
  memAaddr,
  physicalMemAaddr,
  physicalRomAaddr,
  actualGraphicMemory,
  ramAdataRead,
  romAdataRead,
  keyboardData,
  memAdataRead
);

memoryMapping mapingB (
  memBaddr,
  physicalMemBaddr,
  physicalRomBaddr,
  ,
  ramBdataRead,
  romBdataRead,
  keyboardData,
  memBdataRead
);

memoryController memory(
  clkHand,
  physicalMemAaddr, MeMemResult,
  memRW,
  ramAdataRead,
  physicalMemBaddr,
  ramBdataRead,
  memDataBus,
  memAddrBus,
  memRead, memWrite, memEnable
);

romController rom (
  clkHand,
  physicalRomAaddr,
  romAdataRead,
  physicalRomBaddr,
  romBdataRead
);

graphicRam graphicMem (
  clkHand,
  memRW == 2'b01,
  actualGraphicMemory,
  MeMemResult[7:0],
  clkHand,
  renderIndex,
  renderAscii
);

keyboard fakeKeyboard (
  clkHand, rst,
  keyDown, inputValue,
  hardwareInterruptSignal, hardwareInterruptIndex,
  keyboardData
);

endmodule
