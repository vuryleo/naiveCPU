module mem(
  input clk,
  input rst,
  input showData,
  input [15:0] in,
  inout [15:0] data,
  output memRead, memWrite, memEable,
  output [15:0] display
);

wire [15:0] initAddr, initData, increment, addr;
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
)

adder adderMForData (
  initData,
  increment,
  data
)

core coreM (
  clk,
  rst,
  control,
  addr,
  data,
  memRead, memWrite, memEable,
  result
);

selector selectorM (
  showData,
  addr,
  data,
  display
);

endmodule
