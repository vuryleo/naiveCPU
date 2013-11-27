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
wire [15:0] memAaddr, memBaddr, memAdataRead, memBdataRead;
wire [15:0] physicalMemAaddr, physicalMemBaddr;
wire [15:0] ramAdataRead, ramBdataRead, romAdataReadn, romBdataRead;
wire [15:0] IfPC, IfIR;
wire [3:0] registerS, registerM, registerT;
wire [15:0] calResult;

assign leddebug = {ramAdataRead};

cpu naive (
  clkHand, rst,
  memAaddr, memBaddr,
  memDataWrite, memRW,
  memAdataRead, memBdataRead,
  registerValue,
  IfPC, IfIR,
  registerS, registerM, registerT,
  calResult
);

GraphicCard graphic (
  clk, rst,
  registerValue,
  IfPC, IfIR,
  registerS, registerM, registerT,
  calResult,
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
  clk, rst,
  physicalMemAaddr, memDataWrite,
  memRW,
  ramAdataRead,
  physicalMemBaddr,
  ramBdataRead,
  memDataBus,
  memAddrBus,
  memRead, memWrite, memEnable
);

romController rom (
  clk, rst,
  physicalRomAaddr,
  romAdataRead,
  physicalRomBaddr,
  romBdataRead
);

endmodule

