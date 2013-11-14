module RectRenderer (
  input enable,
  input [10:0] x, y,
  input [10:0] cx, cy,
  input [10:0] width, height,
  output reg hit
);

always @ (*)
  if (!enable)
    hit = (x > cx - width >> 1 && x < cx + width >> 1 && y > cy - height >> 1 && y < cy + height >> 1);
  else
    hit = 0;
endmodule

