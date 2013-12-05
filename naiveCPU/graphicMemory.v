module GraphicMemory (
  input [13:0] readIndex,
  input [13:0] writeIndex,
  input [7:0] asciiToWrite,
  input [1:0] control,
  output [7:0] readResult
);

//reg [7:0] memory [2559:0]; // 64*40
reg [7:0] memory [10:0]; // 64*40

assign readResult = memory[readIndex];

always @ (writeIndex or asciiToWrite or control)
  if (control == 2'b01)
    memory[writeIndex] = asciiToWrite;

endmodule
