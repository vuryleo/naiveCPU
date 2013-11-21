module PCadder (
  input clk,
  input [15:0] currentPC,
  output reg [15:0] nextPC
);

reg [15:0] normalNextPC;

always @ (negedge clk)
  nextPC = normalNextPC;

always @ (posedge clk)
  normalNextPC = currentPC + 1;

endmodule
