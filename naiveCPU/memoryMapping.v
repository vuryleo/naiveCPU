module memoryMapping (
  input [15:0] virtualAddr,
  output reg [15:0] actualRamAddr,
  input [15:0] ramData,
  input [7:0] serialPortData,
  input [1:0] serialPortState,
  output reg [15:0] realData,
  output reg [1:0] index
);

localparam RAM = 2'b00,
  SERIALPORT_DATA = 2'b10,
  SERIALPORT_STATE = 2'b11;

always @ (virtualAddr)
begin
  actualRamAddr = virtualAddr;
  if (virtualAddr == 16'hbf00)
    index = SERIALPORT_DATA;
  else if (virtualAddr == 16'hbf01)
    index = SERIALPORT_STATE;
  else
    index = RAM;
end

always @ (*)
  case (index)
    RAM:
      realData = ramData;
    SERIALPORT_DATA:
      realData = {8'h00, serialPortData};
    SERIALPORT_STATE:
      realData = {14'b00000000000000, serialPortState};
    default:
      realData = 0;
  endcase

endmodule
