module Renderer (
  input [9:0] x, y,
  output reg [2:0] r, g, b
);

always @ (x, y)
  if (x < 320)
  begin
    if (y < 240)
    begin
      r = 8;
      g = 0;
      b = 0;
    end
    else
    begin
      r = 0;
      g = 8;
      b = 0;
    end
  end
  else
    if (y < 240)
    begin
      r = 0;
      g = 0;
      b = 8;
    end
    else
    begin
      r = 4;
      g = 4;
      b = 4;
    end
  end
end

