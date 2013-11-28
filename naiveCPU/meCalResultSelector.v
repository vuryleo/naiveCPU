module meCalResultSelector (
  input [1:0] MeMemControl,
  input [15:0] memDataRead,
  input [15:0] ExCalResult,
  output [15:0] MeCalResult
);

assign MeCalResult = MeMemControl == 2'b10? memDataRead : ExCalResult;

endmodule

