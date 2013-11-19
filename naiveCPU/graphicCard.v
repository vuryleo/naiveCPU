module GraphicCard (
  input clk, rst,
  output vgaClk, hs, vs,
  output [2:0] r, g, b,
  output [15:0] leddebug
);

wire [10:0] x, y;
wire [175:0] registerVGA;
reg clk25M;

assign leddebug = {clk25M, x};

always @ (negedge clk, negedge rst)
begin
  if (!rst)
    clk25M = 0;
  else
    clk25M = ~ clk25M;
end

VGAEngine VGAEngineM (
  clk25M,
  rst,
  vgaClk, hs, vs,
  x, y
);

Register registerHeap (
  clk, rst,
  0, 0, 0,
  1, 0,
  1, 0,
  0,
  registerVGA
);

Renderer RendererM (
  x, y,
  registerVGA,
  r, g, b
);

endmodule
