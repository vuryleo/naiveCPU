module Register (
  input clk, rst,
  input readIndexS, readIndexT, readIndexM,
  input tWriteEnable, tToWrite,
  input writeEnable, writeIndex,
  input [15:0] dataToWrite,
  // -- output to vga renderer
  output [175:0] registersVGA,
  output readResultS, readResultT, readResultM,
  output tResuit
);

reg [15:0] registers [0:4'b1010];
reg t;
// 0000 - 0111 R0 - R7;
// 1000 IH
// 1001 SP
// 1010 RA

// -- VGA signal
assign registersVGA = {
  registers[0],
  registers[1],
  registers[2],
  registers[3],
  registers[4],
  registers[5],
  registers[6],
  registers[7],
  registers[8],
  registers[9],
  registers[10]
  };

assign readResultS = registers[readIndexS];
assign readResultT = registers[readIndexT];
assign readResultM = registers[readIndexM];
assign tResuit = t;

always @ (negedge clk, negedge rst)
begin
  if (!rst)
  begin
    registers[0] = 0;
  end
  else
  begin
    if (!writeEnable)
      registers[writeIndex] = dataToWrite;
    if (!tWriteEnable)
      t = tToWrite;
  end
end

endmodule

