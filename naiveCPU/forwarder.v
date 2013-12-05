module forwarder (
  input clk, rst,
  input [15:0] inWord,
  output reg [15:0] outWord
);

reg [15:0] temp;

always @ (negedge clk or negedge rst)
  if (!rst)
    temp = 0;
  else
    temp = inWord;

always @ (posedge clk or negedge rst)
  if (!rst)
    outWord = 0;
  else
    outWord = temp;

endmodule

module forwarder2bit (
  input clk, rst,
  input [1:0] inWord,
  output reg [1:0] outWord
);

reg [1:0] temp;

always @ (negedge clk or negedge rst)
  if (!rst)
    temp = 0;
  else
    temp = inWord;

always @ (posedge clk or negedge rst)
  if (!rst)
    outWord = 0;
  else
    outWord = temp;

endmodule

module forwarder4bit (
  input clk, rst,
  input [3:0] inWord,
  output reg [3:0] outWord
);

reg [3:0] temp;

always @ (negedge clk or negedge rst)
  if (!rst)
    temp = 0;
  else
    temp = inWord;

always @ (posedge clk or negedge rst)
  if (!rst)
    outWord = 0;
  else
    outWord = temp;

endmodule

module forwarder1bit (
  input clk, rst,
  input inWord,
  output reg outWord
);

reg temp;

always @ (negedge clk or negedge rst)
  if (!rst)
    temp = 1;
  else
    temp = inWord;

always @ (posedge clk or negedge rst)
  if (!rst)
    outWord = 1;
  else
    outWord = temp;

endmodule
