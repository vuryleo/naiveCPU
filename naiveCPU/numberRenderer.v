module NumberRenderer (
  input [10:0] x, y,
  input [10:0] cx, cy,
  input [15:0] number,
  output wor hit
);

DigitRenderer first (
  x, y,
  cx - 60, cy,
  number[15:12],
  hit
);

DigitRenderer second (
  x, y,
  cx - 20, cy,
  number[11:8],
  hit
);

DigitRenderer third (
  x, y,
  cx + 20, cy,
  number[7:4],
  hit
);

DigitRenderer last (
  x, y,
  cx + 60, cy,
  number[3:0],
  hit
);

endmodule
