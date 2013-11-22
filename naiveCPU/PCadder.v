module PCadder (
  input clk, rst,
  input [15:0] currentPC,
  output reg [15:0] nextPC
);

wire [15:0] normalNextPC;

always @ (negedge rst, posedge clk)
  if (!rst)
    nextPC = 2;
  else
    nextPC = normalNextPC;

assign normalNextPC = currentPC + 2;

endmodule
