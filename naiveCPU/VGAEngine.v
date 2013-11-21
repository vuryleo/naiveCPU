module VGAEngine (
  input clk, rst,
  output reg hs, vs,
  output reg[10:0] x, y
);

// CLK shall be 25.17 MHz or so.
localparam H_RESULOTION = 640,
  H_FRONT_PORCH = 16,
  H_SYNC_PULSE = 96,
  H_BACK_PORCH = 48,
  H_TOTAL = 800; // Shall be sum of all things above.
localparam V_RESULOTION = 480,
  V_FRONT_PORCH = 10,
  V_SYNC_PULSE = 2,
  V_BACK_PORCH = 33,
  V_TOTAL = 525; // Shall be sum of all things above.

always @ (negedge clk, negedge rst) // x param
begin
  if (!rst)
    x = 0;
  else
  begin
    if (x == H_TOTAL - 1)
      x = 0;
    else
      x = x + 1;
  end
end

always @ (negedge clk, negedge rst) // y param
begin
  if (!rst)
    y = 0;
  else
  begin
    if (x == H_TOTAL - 1)
      if (y == V_TOTAL - 1)
        y = 0;
      else
        y = y + 1;
  end
end

always @ (negedge clk, negedge rst) // hs param
begin
  if (!rst)
    hs = 1;
  else
  begin
    if (x >= H_RESULOTION + H_FRONT_PORCH - 1 && x < H_RESULOTION + H_FRONT_PORCH + H_SYNC_PULSE - 1)
      hs = 0;
    else
      hs = 1;
  end
end

always @ (negedge clk, negedge rst) // vs param
begin
  if (!rst)
    vs = 1;
  else
  begin
    if (y >= V_RESULOTION + V_FRONT_PORCH - 1 && y < V_RESULOTION + V_FRONT_PORCH + V_SYNC_PULSE - 1)
      vs = 0;
    else
      vs = 1;
  end
end

endmodule
