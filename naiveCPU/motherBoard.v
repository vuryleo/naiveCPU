module motherBoard (
  input clk, rst, clkHand,
  inout [15:0] memDataBus,
  output [17:0] memAddrBus,
  output memRead, memWrite, memEnable,
  output vgaHs, vgaVs,
  output [2:0] vgaR, vgaG, vgaB,
  output [15:0] leddebug
);

wire [175:0] registerValue;
wire [15:0] rs;
wire [15:0] memAaddr, memBaddr, memAdataRead, memBdataRead;
wire [1:0] memRW;
wire [15:0] physicalMemAaddr, physicalMemBaddr;
wire [15:0] ramAdataRead, ramBdataRead, romAdataRead, romBdataRead;
wire [15:0] IfPC, IfIR;
wire [15:0] ExCalResult, MeCalResult;

wire [3:0] registerS, registerM, IdRegisterT, MeRegisterT;

assign leddebug = {rs};

cpu naive (
  clkHand, rst,
  memAaddr, memBaddr,
  ExCalResult, memRW,
  memAdataRead, memBdataRead,
  registerValue,
  IfPC, IfIR,
  registerS, registerM, IdRegisterT, MeRegisterT,
  MeCalResult,
  rs
);

GraphicCard graphic (
  clk, rst,
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
  physicalRomAaddr,
  ramAdataRead,
  romAdataRead,
  memAdataRead
);

memoryMapping mapingB (
  memBaddr,
  physicalMemBaddr,
  physicalRomBaddr,
  ramBdataRead,
  romBdataRead,
  memBdataRead
);

memoryController memory(
  clkHand, 
  physicalMemAaddr, ExCalResult,
  memRW,
  ramAdataRead,
  physicalMemBaddr,
  ramBdataRead,
  memDataBus,
  memAddrBus,
  memRead, memWrite, memEnable
);

romController rom (
  clk, 
  physicalRomAaddr,
  romAdataRead,
  physicalRomBaddr,
  romBdataRead
);

endmodule

