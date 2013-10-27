module selector(
  input control,
  input [15:0] dataA, dataB,
  output reg [15:0] data
);

always @*
begin
  case (control)
    0: data <= dataA;
    1: data <= dataB;
  endcase
end
endmodule
