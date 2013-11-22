module PCregister (
  input clk, rst,
  input [15:0] nextPC,
  output reg [15:0] currentPC
);

always @(negedge clk or negedge rst)
  if (!rst)
    currentPC = 16'hFF00;
  else
    currentPC = nextPC;

endmodule
