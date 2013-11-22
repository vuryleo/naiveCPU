module memoryMapping (
  input [15:0] virtualAddr,
  output reg [15:0] actualRamAddr,
  output reg [15:0] actualRomAddr,
  input [15:0] ramData,
  input [15:0] romData,
  output [15:0] realData
);

reg index;

always @ (virtualAddr)
  if (!virtualAddr[15]) // physical mem
  begin
    actualRamAddr = virtualAddr >> 1;
    index = 0;
  end
  else if (virtualAddr[15:8] == 8'hFF) // rom
  begin
    actualRomAddr = {8'h00, virtualAddr[7:0]};
    index = 1;
  end

selector mux (
  index,
  ramData,
  romData,
  realData
);

endmodule
