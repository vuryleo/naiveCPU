module forwarder (
  input clk,
  input [15:0] inWord,
  output reg [15:0] outWord
);

reg [15:0] temp;

always @ (negedge clk)
  temp = inWord;

always @ (posedge clk)
  outWord = temp;

endmodule

module forwarder2bit (
  input clk,
  input [1:0] inWord,
  output reg [1:0] outWord
);

reg [1:0] temp;

always @ (negedge clk)
  temp = inWord;

always @ (posedge clk)
  outWord = temp;

endmodule

module forwarder4bit (
  input clk,
  input [3:0] inWord,
  output reg [3:0] outWord
);

reg [3:0] temp;

always @ (negedge clk)
  temp = inWord;

always @ (posedge clk)
  outWord = temp;

endmodule
