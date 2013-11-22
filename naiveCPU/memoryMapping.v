module memoryMapping (
  input [15:0] virtualAddr,
  output reg [15:0] actualMemAddr
);

always @ (virtualAddr)
  actualMemAddr = virtualAddr / 2;

endmodule
