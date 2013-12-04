module ASCIIRenderer (
  input [10:0] x, y,
  input [7:0] ascii,
  output reg hit
);

reg [10:0] pixel_x, pixel_y;

always @ (ascii or x or y)
begin
  pixel_x = (ascii - 33) + x;
  pixel_y = y;
end

always @ (*)
`include monaco.v

endmodule
