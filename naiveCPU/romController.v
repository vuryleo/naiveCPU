module romController (
  input clk,
  input [15:0] romAaddr,
  output reg [15:0] romAdataRead,
  input [15:0] romBaddr,
  output reg [15:0] romBdataRead
);
// now it is fake

always @ (negedge clk)
  romAdataRead = 16'hEEEE;

always @ (posedge clk)
  romBdataRead = 16'b0110100100000001;// LI R1 $1
  //romBdataRead = 16'b1110000101001101;// ADDU R1 R2 R3

endmodule
