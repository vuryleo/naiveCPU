module motherBoard (
  input clk, rst, clkHand, clkUART,
  inout [15:0] memDataBus,
  output [17:0] memAddrBus,
  output memRead, memWrite, memEnable,
  output vgaHs, vgaVs,
  output [2:0] vgaR, vgaG, vgaB,
  output [15:0] leddebug,
  input tbre, tsre, dataReady,    // wires linked with CPLD
  inout [7:0] ram1DataBus,       // bus
  output rdn, wrn,
  output ram1Oe, ram1We, ram1En
);

wire [175:0] registerValue;
wire [15:0] memAaddr, memBaddr, memAdataRead, memBdataRead, MeMemResult;
wire [7:0] serialPortDataRead;
wire [3:0] serialPortState;
wire [1:0] memRW;
wire [15:0] physicalMemAaddr, physicalMemBaddr;
wire [15:0] ramAdataRead, ramBdataRead;
wire [15:0] IfPC, IfIR;
wire [15:0] ExCalResult, MeCalResult;
wire [1:0] index;

wire [3:0] registerS, registerM, IdRegisterT, MeRegisterT;

reg clk25M, clk12M, clk6M;

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
	 
always @ (negedge clk12M or negedge rst)
  if (!rst)
    clk6M = 0;
  else
    clk6M = ~ clk6M;

assign leddebug = {MeMemResult, tbre, tsre, wrn, rdn, serialPortState};

cpu naive (
  clkUART, rst,
  memAaddr, memBaddr,
  ExCalResult, MeMemResult, memRW,
  memAdataRead, memBdataRead,
  registerValue,
  IfPC, IfIR,
  registerS, registerM, IdRegisterT, MeRegisterT,
  MeCalResult
);

GraphicCard graphic (
  clk25M, rst,
  registerValue,
  IfPC, IfIR,
  registerS, registerM, IdRegisterT, MeRegisterT,
  ExCalResult, MeCalResult,
  vgaHs, vgaVs,
  vgaR, vgaG, vgaB
);

memoryMapping mapingA (
  memAaddr,
  physicalMemAaddr,
  ramAdataRead,
  serialPortDataRead,
  serialPortState[1:0],
  memAdataRead,
  index
);

memoryMapping mapingB (
  memBaddr,
  physicalMemBaddr,
  ramBdataRead,
  serialPortDataRead,
  serialPortState[1:0],
  memBdataRead
);

memoryController memory(
  clkUART,
  physicalMemAaddr, MeMemResult,
  memRW,
  ramAdataRead,
  physicalMemBaddr,
  ramBdataRead,
  memDataBus,
  memAddrBus,
  memRead, memWrite, memEnable
);

serial_port uart(
  clkUART, rst,
  tbre, tsre, dataReady,
  memRW, index,
  MeMemResult,
  ram1DataBus,
  rdn, wrn,
  ram1Oe, ram1We, ram1En,
  serialPortDataRead,
  serialPortState
);

endmodule
