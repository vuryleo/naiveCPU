module RectRenderer (
  input enable,
  input [10:0] x, y,
  input [10:0] cx, cy,
  input [10:0] width, height,
  output reg hit
);

always @ (*)
  if (!enable)
    hit = (x > cx - length >> 1 && x < cx + length >> 1 && y > cy - length >> 1 && y < cy + length >> 1);
  else
    hit = 0;
endmodule

