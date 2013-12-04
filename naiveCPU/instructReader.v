module instructionReader (
  input clk, rst,
  input [15:0] currentPC,
  input [15:0] memRead,
  output reg [15:0] IRaddr,
  output reg [15:0] currentIR
);

always @ (negedge clk)
  IRaddr = currentPC;

always @ (negedge rst or posedge clk)
  if (!rst)
    currentIR = 16'h0800;// nop
  else
    currentIR = memRead;

endmodule
