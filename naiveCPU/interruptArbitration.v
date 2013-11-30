module interruptArbitration(
  input hardwareInterrupt,
  input [3:0] hardwareInterruptIndex,
  input softwareInterrupt,
  input [3:0] softwareInterruptIndex,
  output interruptSignal,
  output [3:0] interruptIndex
);

assign interruptSignal = softwareInterrupt & hardwareInterrupt;
assign interruptIndex = hardwareInterrupt? softwareInterruptIndex : hardwareInterruptIndex;

endmodule
