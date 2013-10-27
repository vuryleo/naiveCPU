module inputState(
  input clk,
  input rst,
  input [15:0] data,
  output reg [15:0] dataA, dataB,
  output reg [3:0] op,
  output reg doCal, showFlag
);

parameter SIZE = 2;
parameter DATAA = 2'b00, DATAB = 2'b01, OP = 2'b10, SF = 2'b11;
reg [SIZE - 1 : 0] state;

always @ (negedge rst or posedge clk)
begin : FSM_SEQ
  if (rst == 0) begin
    state <= #1 DATAA;
  end
  else
  begin
    case (state)
      DATAA: state <= DATAB;
      DATAB: state <= OP;
      OP: state <= SF;
      SF: state <= DATAA;
    endcase
  end
end

always @ (negedge rst or posedge clk)
begin : OUTPUT_LOGIC
  if (rst == 0) begin
    dataA <= 0;
    dataB <= 0;
    doCal <= 0;
    showFlag <= 0;
  end
  else
  begin
    case (state)
      DATAA: dataA <= data;
      DATAB: dataB <= data;
      OP:
      begin
        op <= data[3:0];
        showFlag <= 0;
        doCal <= 1;
      end
      SF:
      begin
        doCal <= 0;
        showFlag <= 1;
      end
    endcase
  end
end
endmodule
