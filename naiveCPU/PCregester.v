module PCregister (
  input [15:0] nextPC,
  output [15:0] currentPC
);

assign currentPC = nextPC;

endmodule
