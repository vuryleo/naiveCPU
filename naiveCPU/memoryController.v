module memoryController (
  input clk, rst,
  // Port A is a dual port that can r/w, option will execute at the negedge
  input [15:0] Aaddr,
  input [15:0] dataWrite, // Only A can write
  input [1:0] rw, // passed as control
  output reg [15:0] AdataRead,
  // Port B is a read only port, it will read at the posedge
  input [15:0] Baddr,
  output reg [15:0] BdataRead,

  inout [15:0] dataBus,
  output reg [17:0] addrBus;
  output reg memRead, memWrite,
  output memEnable,
);

wire [15:0] addr;
reg [15:0] dataRead;
wire [1:0] control;

always @ (clk)
begin
  if (!clk) // negedge
  begin
    addr = Aaddr;
    control = rw;
  end
  else // posedge
  begin
    addr = Baddr;
    control = 2'b10;
  end
end

always @ (dataRead)
  if (!clk) // negedge
    AdataRead = dataRead;
  else // posedge
    BdataRead = dataRead;

Memory mem (
  clk, rst,
  control,
  addr, dataWrite,
  dataBus, addrBus,
  dataRead,
  memRead, memWrite, memEnable
);

endmodule
