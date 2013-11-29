module PCadder (
  input clk, rst,
  input [15:0] currentPCIn,
  input [15:0] instructionIn,
  input [15:0] rs,
  input t,
  input [2:0] jumpControl,
  output [15:0] nextPC
);

localparam  IDLE = 3'b000,
  EQZ = 3'b001,
  NEZ = 3'b010,
  TEQZ = 3'b011,
  TNEZ = 3'b100,
  JUMP = 3'b101,
  DB = 3'b110;

reg [15:0] currentPC, instruction, jumpPC;
reg jump;

wire[15:0] imm16s = {instruction[7] ? 8'hff : 8'h00, instruction[7:0]};

always @ (negedge clk or negedge rst)
  if (!rst)
  begin
    instruction = 16'b0000100000000000;
	 currentPC = 0;
  end
  else
  begin
    instruction = instructionIn;
	 currentPC = currentPCIn;
  end

always @ (*)
begin
  jumpPC = 0;
  jump = 0;
  if (!rst)
  begin
    jumpPC = 0;
    jump = 0;
  end
  else
  begin
    case (jumpControl)
      EQZ:
        if (rs == 0)
        begin
          jumpPC = currentPC + imm16s;
          jump = 1;
        end
      NEZ:
        if (rs != 0)
        begin
          jumpPC = currentPC + imm16s;
          jump = 1;
        end
      TEQZ:
        if (t == 0)
        begin
          jumpPC = currentPC + imm16s;
          jump = 1;
        end
      TNEZ:
        if (t != 0)
        begin
          jumpPC = currentPC + imm16s;
          jump = 1;
        end
      JUMP:
        begin
          jumpPC = rs;
          jump = 1;
        end
      DB:
        begin
          jumpPC = currentPC + imm16s;
          jump = 1;
        end
    endcase
  end
end

assign nextPC = jump? jumpPC : currentPC + 2;

endmodule
