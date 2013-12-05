module GraphicMemory (
  input [13:0] readIndex,
  input [13:0] writeIndex,
  input [7:0] asciiToWrite,
  output [7:0] readResult
);

//reg [7:0] memory [2559:0]; // 64*40
reg [7:0] memory [10:0]; // 64*40

assign readResult = memory[readIndex];

always @ (writeIndex or asciiToWrite)
  if (writeIndex >= 0 && writeIndex < 2560)
    memory[writeIndex] = asciiToWrite;

endmodule
