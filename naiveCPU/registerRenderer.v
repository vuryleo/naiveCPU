module registerRenderer (
  input [10:0] x, y,
  input [10:0] cx, cy,
  input [3:0] registerIndex,
  input [15:0] registerValue,
  output wor hit
);

DigitRenderer index (
  x, y,
  cx - 100, cy,
  registerIndex,
  hit
);

NumberRenderer value (
  x, y,
  cx + 40, cy,
  registerValue,
  hit
);

endmodule
