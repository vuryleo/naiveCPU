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
    4'h0: enable = 7'b1000000;
    4'h1: enable = 7'b1111001;
    4'h2: enable = 7'b0100100;
    4'h3: enable = 7'b0110000;
    4'h4: enable = 7'b0011001;
    4'h5: enable = 7'b0010010;
    4'h6: enable = 7'b0000010;
    4'h7: enable = 7'b1111000;
    4'h8: enable = 7'b0000000;
    4'h9: enable = 7'b0010000;
    4'hA: enable = 7'b0001000;
    4'hb: enable = 7'b0000011;
    4'hC: enable = 7'b1000110;
    4'hd: enable = 7'b0100001;
    4'hE: enable = 7'b0000110;
    4'hF: enable = 7'b0001110;
  endcase
end

RectRenderer pos0 (
  enable[0],
  x, y,
  cx, cy - 20,
  10, 5,
  hit
);

RectRenderer pos1 (
  enable[1],
  x, y,
  cx + 15, cy - 10,
  5, 10,
  hit
);

RectRenderer pos2 (
  enable[2],
  x, y,
  cx + 15, cy + 10,
  5, 10,
  hit
);

RectRenderer pos3 (
  enable[3],
  x, y,
  cx, cy + 20,
  10, 5,
  hit
);

RectRenderer pos4 (
  enable[4],
  x, y,
  cx - 15, cy + 10,
  5, 10,
  hit
);

RectRenderer pos5 (
  enable[5],
  x, y,
  cx - 15, cy - 10,
  5, 10,
  hit
);

RectRenderer pos6 (
  enable[6],
  x, y,
  cx, cy,
  10, 5,
  hit
);

endmodule
