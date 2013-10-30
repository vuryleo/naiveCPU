module core (
  input clk,
  input rst,
  input [1:0] control,
  input [15:0] addr, dataWrite,
  inout [15:0] dataBus,
  output reg [15:0] addrBus, dataRead,
  output reg memRead, memWrite, memEnable
);

parameter IDLE = 2'b00,
  WRITE = 2'b01,
  READ = 2'b10;

assign dataBus = (memWrite==0)? dataWrite:16'bz;

initial
begin
  dataRead <= 0;
  memWrite <= 1;
  memRead <= 1;
  memEnable <= 1; // Just keep mem enable
end

always @ (addr)
begin
  addrBus <= addr;
end

always @ (negedge rst or posedge clk)
begin : CORE
  if (rst == 0) begin
    dataRead <= 0;
    memWrite <= 1;
    memRead <= 1;
    memEnable <= 1; // Just keep mem enable
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
        dataRead <= dataBus;
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
