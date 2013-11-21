module motherBoard (
  input clk, rst,
  inout [15:0] memDataBus,
  output [17:0] memAddrBus,
  output memRead, memWrite, memEnable,
  output vgaHs, vgaVs,
  output [2:0] vgaR, vgaG, vgaB
);

wire [175:0] registers;
wire [15:0] memAaddr, memBaddr, memAdataRead, memBdataRead;

cpu naive (
  clk, rst,
  memAaddr, memBaddr,
  memDataWrite, memRW,
  memAdataRead, memBdataRead,
  registers
);

GraphicCard graphic (
  clk, rst,
  registers,
  vgaHs, vgaVs,
  vgaR, vgaG, vgaB
);

memoryController (
  clk, rst,
  memAaddr, memDataWrite,
  memRW,
  memAdataRead,
  memBaddr,
  memBdataRead,
  memDataBus,
  memAddrBus,
  memRead, memWrite, memEnable
);

endmodule

