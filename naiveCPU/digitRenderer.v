module DigitRenderer (
  input [10:0] x, y,
  input [10:0] cx, cy,
  input [3:0] digit,
  output wor hit
);

reg [6:0] enable;
//  -     [0]
// | |  [5] [1]
//  -     [6]
// | |  [4] [2]
//  -     [3]

always @ (digit)
begin
  case (digit)
    1'h0: enable = 7'b1000000;
    1'h1: enable = 7'b1111001;
    1'h2: enable = 7'b0100100;
    1'h3: enable = 7'b0110000;
    1'h4: enable = 7'b0011001;
    1'h5: enable = 7'b0010010;
    1'h6: enable = 7'b0000010;
    1'h7: enable = 7'b1111000;
    1'h8: enable = 7'b0000000;
    1'h9: enable = 7'b0010000;
    1'hA: enable = 7'b0001000;
    1'hb: enable = 7'b0000111;
    1'hC: enable = 7'b1000110;
    1'hd: enable = 7'b0100001;
    1'hE: enable = 7'b0000110;
    1'hF: enable = 7'b0001110;
  endcase
end

RectRenderer pos0 (
  enable[0],
  x, y,
  cx, cy - 15,
  20, 10,
  hit
);

RectRenderer pos1 (
  enable[1],
  x, y,
  cx + 25, cy - 10,
  10, 20,
  hit
);

RectRenderer pos2 (
  enable[2],
  x, y,
  cx + 25, cy + 10,
  10, 20,
  hit
);

RectRenderer pos3 (
  enable[3],
  x, y,
  cx, cy + 15,
  20, 10,
  hit
);

RectRenderer pos4 (
  enable[4],
  x, y,
  cx - 25, cy + 10,
  10, 20,
  hit
);

RectRenderer pos5 (
  enable[5],
  x, y,
  cx - 25, cy - 10,
  10, 20,
  hit
);

RectRenderer pos6 (
  enable[6],
  x, y,
  cx, cy,
  20, 10,
  hit
);

endmodule
