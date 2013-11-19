module Renderer (
  input [10:0] x, y,
  input [175:0] registers,
  output reg [2:0] r, g, b
);

wor hit;

always @ (x, y)
begin
  r = 0;
  g = 0;
  b = 0;
  if (x < 640 && y < 480)
    if (hit)
    begin
      r = 7;
      g = 7;
      b = 7;
    end
end

registerRenderer register0 (
  x, y,
  200, 80,
  0, registers[175:160],
  hit
);

registerRenderer register1 (
  x, y,
  200, 160,
  1, registers[159:144],
  hit
);

registerRenderer register2 (
  x, y,
  200, 240,
  2, registers[143:128],
  hit
);

endmodule
