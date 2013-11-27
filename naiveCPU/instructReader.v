module instructionReader (
  input clk, rst,
  input [15:0] currentPC,
  input [15:0] memRead,
  output reg [15:0] IRaddr,
  output reg [15:0] currentIR
);

always @ (negedge clk)
  IRaddr = currentPC;

always @ (posedge clk or negedge rst)
  if (!rst)
    currentIR = 0;
  else
    currentIR = memRead;

endmodule
