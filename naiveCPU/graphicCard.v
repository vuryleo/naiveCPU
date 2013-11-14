module GraphicCard (
  input clk, rst,
  output reg vgaClk, hs, vs,
  output reg[2:0] r, g, b
);

wire [9:0] x, y;

VGAEngine VGAEngineM (
  clk,
  rst,
  vgaClk, hs, vs,
  x, y
);

Renderer RendererM (
  x, y,
  r, g, b
);

