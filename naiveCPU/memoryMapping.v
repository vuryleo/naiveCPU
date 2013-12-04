module memoryMapping (
  input [15:0] virtualAddr,
  output reg [15:0] actualRamAddr,
  output reg [15:0] actualRomAddr,
  output reg [13:0] actualGraphicAddr,
  input [15:0] ramData,
  input [15:0] romData,
  input [15:0] keyboardData,
  output reg [15:0] realData
);

localparam RAM = 2'b00,
  KEYBOARD = 2'b01,
  ROM = 2'b10,
  GRAPHIC = 2'b11;

reg [1:0] index;

always @ (virtualAddr)
  if (!virtualAddr[15]) // physical mem
  begin
    actualRamAddr = virtualAddr >> 1;
    index = RAM;
  end
  else if (virtualAddr[15:8] == 8'hFF) // rom
  begin
    actualRomAddr = {8'h00, virtualAddr[7:0]};
    index = ROM;
  end
  else if (virtualAddr[15:8] >= 8'hf0 && virtualAddr[15:8] < 8'hFA) // graphic
  begin
    actualGraphicAddr = (virtualAddr - 16'hf000)[13:0];
    index = GRAPHIC;
  end
  else if (virtualAddr == 16'hFE00) // keyboard
  begin
    index = KEYBOARD;
  end

always @ (*)
  case (index)
    RAM:
      realData = ramData;
    KEYBOARD:
      realData = keyboardData;
    ROM:
      realData = romData;
    default:
      realData = 0;
  endcase

endmodule
