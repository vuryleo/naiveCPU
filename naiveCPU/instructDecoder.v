module instructDecoder (
  input clk, rst,
  input [15:0] instruct,
  output reg [3:0] operator, // length is unclear for now
  output reg [3:0] registerS, registerT, registerM,
  output reg [15:0] imm
);

always @ (negedge clk or negedge rst)
begin
end
  if (!rst)
  begin
    operator = 4'b0000;
    registerS = 4'b0000;
    registerT = 4'b0000;
    registerM = 4'b0000;
    imm = 16'h0000;
  end
  else
  begin

  end
endmodule
