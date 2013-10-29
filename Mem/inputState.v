module inputState(
  input clk,
  input rst,
  input [15:0] in,
  output reg [15:0] addr, data, increment,
  output reg [1:0] control
);

parameter SIZE = 2;
parameter MAX_INCREMENT = 10;
parameter ADDR = 2'b00, DATA = 2'b01, WRITE = 2'b10, READ = 2'b11;
reg [SIZE - 1 : 0] state;

initial
begin
  state <= ADDR;
  data <= 0;
  addr <= 0;
  increment <= 0;
  control <= 2'b00;
end

always @ (negedge rst or posedge clk)
begin : FSM_SEQ
  if (rst == 0)
  begin
    state <= ADDR;
    increment <= 0;
  end
  else
  begin
    case (state)
      ADDR: state <= DATA;
      DATA: state <= WRITE;
      WRITE:
      begin
        if (increment == MAX_INCREMENT)
        begin
          state <= READ;
          increment <= 0;
        end
        else
        begin
          state <= WRITE;
          increment <= increment + 1;
        end
      end
      READ:
      begin
        if (increment == MAX_INCREMENT)
        begin
          state <= ADDR;
          increment <= 0;
        end
        else
        begin
          state <= READ;
          increment <= increment + 1;
        end
      end
    endcase
  end
end

always @ (negedge rst or posedge clk)
begin : OUTPUT_LOGIC
  if (rst == 0)
  begin
    data <= 0;
    addr <= 0;
  end
  else
  begin
    case (state)
      ADDR:
      begin
        addr <= in;
        control <= 2'b00;
      end
      DATA:
      begin
        data <= in;
        control <= 2'b00;
      end
      WRITE: control <= 2'b01;
      READ: control <= 2'b10;
    endcase
  end
end
endmodule

