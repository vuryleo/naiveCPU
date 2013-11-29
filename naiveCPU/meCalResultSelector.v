module meCalResultSelector (
  input clk, rst,
  input [1:0] MeMemControl,
  input [15:0] memDataRead,
  input [15:0] ExCalResultIn,
  output [15:0] MeCalResult
);

reg [15:0] ExCalResult;

always @ (negedge clk or negedge rst)
  if (!rst)
    ExCalResult = 0;
  else
    ExCalResult = ExCalResultIn;

assign MeCalResult = (MeMemControl == 2'b10)? memDataRead : ExCalResult;

endmodule

