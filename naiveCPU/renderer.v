module Renderer (
  input [10:0] x, y,
  output reg [2:0] r, g, b
);

always @ (x, y)
begin
  r = 0;
  g = 0;
  b = 0;
  if (x < 320)
  begin
    if (y < 240)
    begin
      r = 7;
      g = 0;
      b = 0;
    end
    else if (y < 480)
    begin
      r = 0;
      g = 7;
      b = 0;
    end
  end
  else if (x < 640)
    if (y < 240)
    begin
      r = 0;
      g = 0;
      b = 7;
    end
    else if (y < 480)
    begin
      r = 4;
      g = 4;
      b = 4;
    end
end

endmodule
