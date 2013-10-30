module mem(
  input clk,
  input rst,
  input showData,
  input [15:0] in,
  inout [15:0] dataBus,
  output memRead, memWrite, memEnable,
  output [15:0] addrBus, display
);

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
  clk,
  rst,
  control,
  addr,
  dataWrite,
  dataBus,
  addrBus,
  dataRead,
  memRead, memWrite, memEnable
);

selector selectorM (
  showData,
  addr,
  dataRead,
  display
);

endmodule
