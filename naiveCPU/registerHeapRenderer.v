module RegisterHeapRenderer (
  input [10:0] x, y,
  input [10:0] cx, cy,
  input [175:0] registers,
  output wor hit
);

localparam deltaY = 60;

registerRenderer register0 (
  x, y,
  cx, cy - deltaY * 3 - deltaY / 2,
  0, registers[175:160],
  hit
);

registerRenderer register1 (
  x, y,
  cx, cy - deltaY * 2 - deltaY / 2,
  1, registers[159:144],
  hit
);

//registerRenderer register2 (
//  x, y,
//  cx, cy - deltaY - deltaY / 2,
//  2, registers[143:128],
//  hit
//);

//registerRenderer register3 (
//  x, y,
//  cx, cy - deltaY / 2,
//  3, registers[127:112],
//  hit
//);

//registerRenderer register4 (
//  x, y,
//  cx, cy + deltaY / 2,
//  4, registers[111:96],
//  hit
//);

//registerRenderer register5 (
//  x, y,
//  cx, cy + deltaY + deltaY / 2,
//  5, registers[95:80],
//  hit
//);
//
registerRenderer register6 (
  x, y,
  cx, cy + deltaY * 2 + deltaY / 2,
  6, registers[79:64],
  hit
);

registerRenderer register7 (
  x, y,
  cx, cy + deltaY * 3 + deltaY / 2,
  7, registers[63:48],
  hit
);

//registerRenderer register8 (
//  x, y,
//  cx, cy + deltaY * 3 + deltaY / 2,
//  8, registers[47:32],
//  hit
//);
//
//registerRenderer register9 (
//  x, y,
//  cx, cy + deltaY * 4 + deltaY / 2,
//  9, registers[31:16],
//  hit
//);

//registerRenderer registera (
//  x, y,
//  cx, cy + deltaY * 4 + deltaY / 2,
//  4'ha, registers[15:0],
//  hit
//);

endmodule
