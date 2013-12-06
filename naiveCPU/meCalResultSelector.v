module meCalResultSelector (
  input clk, rst,
  input [1:0] MeMemControl,
  input [15:0] memDataRead,
  input [15:0] ExCalResultIn,
  output [15:0] MeCalResult
);

reg [15:0] ExCalResult;
//reg [15:0] MeReadResult;

always @ (negedge clk or negedge rst)
  if (!rst)
  begin
    ExCalResult = 0;
    //MeReadResult = 0;
  end
  else
  begin
    ExCalResult = ExCalResultIn;
    //MeReadResult = memDataRead;
  end

assign MeCalResult = MeMemControl[1]? memDataRead : ExCalResult;

endmodule

