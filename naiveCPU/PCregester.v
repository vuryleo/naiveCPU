module PCregister (
  input clk, rst,
  input [15:0] nextPC,
  output reg [15:0] currentPC
);

always @(negedge clk or negedge rst)
  if (!rst)
    currentPC = 0;
  else
    currentPC = nextPC;

endmodule
