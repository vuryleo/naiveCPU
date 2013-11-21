module cpu (
  input clk, rst,
  output [15:0] Aaddr, Baddr,
  output [15:0] dataWrtie,
  output [1:0] rw,
  input [15:0] AmemRead, BmemRead,
  output [175:0] registers
);

Register registerFile (
  clk, rst,
  0, 0, 0,
  1, 0,
  1, 0,
  0,
  registers
);

endmodule

