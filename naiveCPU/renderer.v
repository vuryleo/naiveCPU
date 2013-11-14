module Renderer (
  input [10:0] x, y,
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
      g = 0;
      b = 0;
    end
end

DigitRenderer test0 (
  x, y,
  320, 240,
  0,
  hit
);

DigitRenderer test1 (
  x, y,
  320 + 40, 240,
  1,
  hit
);

DigitRenderer test2 (
  x, y,
  320 + 80, 240,
  2,
  hit
);

DigitRenderer test3 (
  x, y,
  320 + 120, 240,
  3,
  hit
);

DigitRenderer test4 (
  x, y,
  320, 240 + 60,
  4,
  hit
);

DigitRenderer test5 (
  x, y,
  320 + 40, 240 + 60,
  5,
  hit
);

DigitRenderer test6 (
  x, y,
  320 + 80, 240 + 60,
  6,
  hit
);

DigitRenderer test7 (
  x, y,
  320 + 120, 240 + 60,
  7,
  hit
);

DigitRenderer test8 (
  x, y,
  320, 240 + 120,
  8,
  hit
);

DigitRenderer test9 (
  x, y,
  320 + 40, 240 + 120,
  9,
  hit
);

DigitRenderer testA (
  x, y,
  320 + 80, 240 + 120,
  4'ha,
  hit
);

DigitRenderer testB (
  x, y,
  320 + 120, 240 + 120,
  4'hb,
  hit
);


DigitRenderer testC (
  x, y,
  320, 240 + 180,
  4'hc,
  hit
);

DigitRenderer testD (
  x, y,
  320 + 40, 240 + 180,
  4'hd,
  hit
);

DigitRenderer testE (
  x, y,
  320 + 80, 240 + 180,
  4'he,
  hit
);

DigitRenderer testF (
  x, y,
  320 + 120, 240 + 180,
  4'hf,
  hit
);

endmodule
