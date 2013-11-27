module Renderer (
  input [10:0] x, y,
  input [175:0] registerValue,
  input [15:0] IfPC, IfIR,
  input [15:0] calResult,
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

RegisterHeapRenderer registerFile (
  x, y,
  200, 240,
  registerValue,
  hit
);

IFRenderer ifResgisters (
  x, y,
  500, 80,
  IfPC, IfIR,
  hit
);

registerRenderer renderCalResult (
  x, y,
  500, 240,
  4'hE, calResult,
  hit
);

endmodule
