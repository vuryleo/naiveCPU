module core (
  input clk,
  input rst,
  input [1:0] control,
  input [15:0] addr,
  inout reg [15:0] data,
  output reg memRead, memWrite, memEable
);

parameter IDLE = 2'b00,
  WRITE = 2'b01,
  READ = 2'b10;

initial
begin
  data <= 0;
  memWrite <= 1;
  memRead <= 1;
  memEable <= 1; // Just keep mem enable
end

always @ (negedge rst or posedge clk)
begin : CORE
  if (rst == 0) begin
    data <= 0;
    memWrite <= 1;
    memRead <= 1;
  end
  else
  begin
    case (control)
      WRITE:
      begin
        memRead <= 1;
        memWrite <= 0;
      end
      READ:
      begin
        memWrite <= 1;
        memRead <= 0;
      end
      default:
      begin
        memWrite <= 1;
        memRead <= 1;
      end
    endcase
  end
end

endmodule
