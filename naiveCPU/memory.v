module Memory (
  input [1:0] control,
  input [15:0] addr, dataWrite,
  inout [15:0] dataBus,
  output reg [17:0] addrBus,
  output reg [15:0] dataRead,
  output reg memRead, memWrite,
  output memEnable
);

parameter IDLE = 2'b00,
  WRITE = 2'b01,
  READ = 2'b10;

assign dataBus = memWrite? 16'bZZZZZZZZZZZZZZZZ:dataWrite;

assign memEnable = 0;

initial
begin
  dataRead <= 0;
  memWrite <= 1;
  memRead <= 1;
end

always @ (addr)
  addrBus = addr;

always @ (dataBus)
  dataRead <= dataBus;

always @ (control)
begin
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
