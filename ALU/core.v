module core (
  clk,
  rst,
  dataA,
  dataB,
  op,
  result,
  flags
);

input clk;
input rst;
input dataA;
input dataB;
input op;

output result;
output flags;

wire clk;
wire rst;
wire [15:0] dataA, dataB;
wire [3:0] op;
reg [15:0] result;
reg [15:0] flags;

parameter ADD = 4'b0000,
  SUB = 4'b0001,
  AND = 4'b1000,
  OR  = 4'b1001,
  XOR = 4'b1010,
  NOT = 4'b1011,
  SLL = 4'b1100,
  SRL = 4'b1101,
  SRA = 4'b0010,
  ROL = 4'b0011;


always @ (negedge rst or posedge clk)
begin : CORE
  if (rst == 0) begin
    result <= 0;
  end
  else
  begin
    case (op)
      ADD: result <= dataA + dataB;
      SUB: result <= dataA - dataB;
      OR:  result <= dataA | dataB;
      XOR: result <= dataA ^ dataB;
      NOT:
        if (dataA == 0) begin
          result <= 1;
        end else begin
          result <= 0;
        end
      SLL: result <= dataA << dataB;
      SRL: result <= dataA >> dataB;
      SRA: result <= dataA >>> dataB;
      ROL: result <= (dataA >> dataB) | dataA << (16 - dataB);
		default: result <= op;
    endcase
  end
end

endmodule
