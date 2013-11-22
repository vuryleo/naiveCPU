module IFIDregister (
  input [15:0] instructionIn,
  output reg [15:0] instructionOut,
  input [15:0] currentPCIn,
  output reg [15:0]currentPCOut
);

always @(instructionIn)
  instructionOut = instructionIn;

always @(currentPCIn)
  currentPCOut = currentPCOut;

endmodule

