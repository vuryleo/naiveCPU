module GraphicCard (
  input clk, rst,
  input [175:0] registerVGA,
  input [15:0] IfPC, IfIR,
  input [3:0] registerS, registerM, IdRegisterT, MeRegisterT,
  input [15:0] ExCalResult, MeCalResult,
  output hs, vs,
  output [2:0] r, g, b
);

wire [10:0] x, y;

VGAEngine VGAEngineM (
  clk,
  rst,
  hs, vs,
  x, y
);

Renderer RendererM (
  x, y,
  registerVGA,
  IfPC, IfIR,
  registerS, registerM, IdRegisterT, MeRegisterT,
  ExCalResult, MeCalResult,
  r, g, b
);

endmodule

