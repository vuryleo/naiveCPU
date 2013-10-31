module mem(
  input clk,
  input clk50M,
  input rst,
  input showData,
  input [15:0] in,
  inout [15:0] dataBus,
  output memRead, memWrite, memEnable,
  output [17:0] addrBus,
  output [15:0] display
);
/*
assign dataBus = 16'hffff;
assign memRead = 1, memWrite = 0, memEnable = 0;
assign addrBus = 18'b0;
assign display = 0;
*/

wire [15:0] initAddr, initData, increment, addr, dataWrite, dataRead;
wire [1:0] control;

inputState inputStateM (
  clk,
  rst,
  in,
  initAddr,
  initData,
  increment,
  control
);

adder adderMForAddr (
  initAddr,
  increment,
  addr
);

adder adderMForData (
  initData,
  increment,
  dataWrite
);

core coreM (
  clk50M,
  rst,
  control,
  addr,
  dataWrite,
  dataBus,
  addrBus,
  dataRead,
  memRead, memWrite,
  //bufRead, bufWrite,
  memEnable
);

selector selectorM (
  showData,
  dataWrite,
  dataRead,
  display
);

endmodule
