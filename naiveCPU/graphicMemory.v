module GraphicMemory (
  input [13:0] readIndex,
  input [13:0] writeIndex,
  input writeEnable,
  input [7:0] asciiToWrite,
  output [7:0] readResult
);

reg [7:0] memory [2560]; // 64*40

assign readResult = memory[readIndex];

always @ (writeIndex or writeEnable)
  if (!writeEnable)
    memory[writeIndex] = asciiToWrite;

endmodule
