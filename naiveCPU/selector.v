module selector(
  input control,
  input [15:0] dataA, dataB,
  output [15:0] data
);

assign data = control? dataB : dataA;

endmodule
