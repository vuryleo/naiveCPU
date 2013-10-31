module adder (
  input [15:0] dataA,
  input [15:0] dataB,
  output reg [15:0] result
);

initial result <= 0;

always @ (dataA, dataB)
begin : ADD
  result = dataA + dataB;
end
endmodule

