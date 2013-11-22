module IFRenderer (
  input [10:0] x, y,
  input [10:0] cx, cy,
  input [15:0] pc, ir,
  output wor hit
);

registerRenderer pcRenderer (
  x, y,
  cx, cy - 30,
  4'hc, pc,
  hit
);

registerRenderer irRenderer (
  x, y,
  cx, cy + 30,
  4'h1, ir,
  hit
);

endmodule
