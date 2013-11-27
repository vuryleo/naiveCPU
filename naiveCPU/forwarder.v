module forwarder (
  input clk, rst,
  input [15:0] inWord,
  output reg [15:0] outWord
);

always @ (negedge clk or negedge rst)
  if (!rst)
    outWord = 0;
  else
    outWord = inWord;

endmodule