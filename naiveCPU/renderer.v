module Renderer (
  input [10:0] x, y,
  input [175:0] registers,
  input [15:0] IfPC, IfIR,
  output reg [2:0] r, g, b
);

wor hit;

always @ (x, y, hit)
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

RegisterHeapRenderer registerHeap (
  x, y,
  200, 240,
  registers,
  hit
);

IFRenderer ifResgisters (
  x, y,
  500, 80,
  IfPC, IfIR,
  hit
);

endmodule
