module Renderer (
  input [10:0] x, y,
  output reg [2:0] r, g, b
);

wire hit;

always @ (x, y)
begin
  r = 0;
  g = 0;
  b = 0;
  if (x < 640 && y < 480)
    if (hit)
    begin
      r = 7;
      g = 0;
      b = 0;
    end
end

DigitRenderer test (
  x, y,
  320, 240,
  0,
  hit
);

endmodule
