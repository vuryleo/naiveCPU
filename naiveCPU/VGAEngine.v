module VGAEngine (
  input clk, rst,
  output reg vgaClk, hs, vs,
  output reg[9:0] x, y
);

reg [9:0] xt, yt;
reg hst, vst;

// CLK shall be 25.17 MHz or so.
localparam H_RESULOTION = 640,
  H_FRONT_PORCH = 16,
  H_SYNC_PULSE = 96,
  H_BACK_PORCH = 48,
  H_TOTAL = 800; // Shall be sum of all things above.
localparam V_RESULOTION = 480,
  V_FRONT_PORCH = 11,
  V_SYNC_PULSE = 2,
  V_BACK_PORCH = 31,
  V_TOTAL = 524; // Shall be sum of all things above.

always @ (clk)
  vgaClk = clk;

always @ (clk, rst) // x param
begin
  if (!rst)
    xt = 0;
  else if (clk)
  begin
    if (xt == H_TOTAL)
      xt = 0;
    else
      xt = xt + 1;
  end
  x = xt;
end

always @ (clk, rst) // y param
begin
  if (!rst)
    yt = 0;
  else if (clk)
  begin
    if (yt == V_TOTAL)
      yt = 0;
    else
      yt = yt + 1;
  end
  y = yt;
end

always @ (clk, rst) // hs param
begin
  if (!rst)
    hst = 0;
  else if (clk)
  begin
    if (xt >= H_RESULOTION + H_FRONT_PORCH - 1 && xt < H_RESULOTION + H_FRONT_PORCH + H_SYNC_PULSE)
      hst = 0;
    else
      hst = 1;
  end
end

always @ (clk, rst) // vs param
begin
  if (!rst)
    vst = 0;
  else if (clk)
  begin
    if (yt >= V_RESULOTION + V_FRONT_PORCH - 1 && yt < V_RESULOTION + V_FRONT_PORCH + V_SYNC_PULSE)
      vst = 0;
    else
      vst = 1;
  end
end

always @ (clk, rst) // hs output
begin
  if (!rst)
    hs = 0;
  else if (clk)
  begin
    hs = hst;
end

always @ (clk, rst) // vs output
begin
  if (!rst)
    vs = 0;
  else if (clk)
  begin
    vs = vst;
end

