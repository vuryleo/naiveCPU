module serial_port(
  input clk, rst,              // clk & rst
  input tbre, tsre, dataReady,    // wires linked with CPLD
  input [1:0] mode, index,
  input [7:0] dataToSend,    // toggle switches controlling data to send to serial port
  inout [7:0] ram1Data,       // bus
  output reg rdn, wrn,
  output ram1Oe, ram1We, ram1En,
  output reg [7:0] data,
  output [3:0] status
);

localparam MODE_WRITE = 2'b01;
localparam MODE_READ = 2'b10;
localparam IDLE = 2'b00,
  READ = 2'b10,
  WRITE = 2'b01,
  READ_IDLE = 2'b11;

wire busWritten;

assign status = {dataReady, tbre & tsre};

assign busWritten = (mode == MODE_WRITE);
assign ram1Data = busWritten ? dataToSend : 8'bzzzzzzzz;
assign ram1Oe = 1;
assign ram1We = 1;
assign ram1En = 1;

always @(*) begin
  rdn <= 1;
  wrn <= 1;
  if (!rst)
  begin
	 rdn <= 1;
	 wrn <= 1;
  end
  else
  begin
    if (clk) // posedge
	 if (index == 2'b10 && mode == MODE_WRITE)
		wrn <= 0;
    else if (index == 2'b10 && mode == MODE_READ)
	 begin
      rdn <= 0;
      data <= ram1Data;
   end
	end
end
endmodule
