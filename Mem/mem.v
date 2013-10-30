module mem(
  input clk,
  input rst,
  input showData,
  input [15:0] in,
  inout [15:0] dataBus,
  output memRead, memWrite, memEable,
  output [15:0] display
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
  dataRead,
  memRead, memWrite, memEable
);

selector selectorM (
  showData,
  addr,
  dataRead,
  display
);

endmodule
