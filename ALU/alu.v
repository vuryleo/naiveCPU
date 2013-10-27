module alu(
  input clk,
  input rst,
  input [15:0] data,
  output [15:0] display
);

wire [15:0] dataA, dataB;
wire [15:0] result, flags;
wire [3:0] op;
wire doCal, showFlag;

inputState inputStateM (
  clk,
  rst,
  data,
  dataA,
  dataB,
  op,
  doCal,
  showFlag
);

core coreM (
  doCal,
  rst,
  dataA,
  dataB,
  op,
  result,
  flags
);

selector selectorM (
  showFlag,
  result,
  flags,
  display
);

endmodule
