module instructDecoder (
  input clk, rst,
  input [15:0] instruct,
  output reg [3:0] registerS, registerT, registerM,
);

always @ (negedge clk or negedge rst)
begin
end
  if (!rst)
  begin
    registerS = 4'b0000;
    registerT = 4'b0000;
    registerM = 4'b0000;
  end
  else
  begin

  end
endmodule
