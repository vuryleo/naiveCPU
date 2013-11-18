module Register (
  input clk, rst,
  input readIndexS, readIndexT, readIndexM,
  input tWriteEnable,
  input tToWrite,
  input writeEnable,
  input writeIndex,
  input [15:0] dataToWrite,
  output readResultS, readResultT, readResultM,
  output tResuit
);

reg [15:0] registers [0:4'b1010];
reg t;
// 0000 - 0111 R1 - R7;
// 1000 IH
// 1001 SP
// 1010 RA

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

