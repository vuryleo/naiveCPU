module IFIDregister (
  input [15:0] instructionIn,
  output reg [15:0] instructionOut
);

always @(instructionIn)
  instructionOut = instructionIn;

endmodule

