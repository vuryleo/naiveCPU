module alu(
  input clk, rst,
  input[15:0] rsIn, rmIn,
  input[15:0] currentPCIn, instructionIn,
  output reg[15:0] res,
  output reg t_written, t
);

reg [15:0] currentPC, instruction, rs, rm;

wire[15:0] imm16 = {8'd0, instruction[7:0]};
wire[15:0] imm16s = {instruction[7] ? 8'hff : 8'h00, instruction[7:0]};
wire[15:0] imm16from4s = {instruction[3] ? 8'hff : 8'h00, instruction[3:0]};
wire[3:0] shift_imm4 = instruction[4:2] ? instruction[4:2] : 8;

always @ (negedge clk or negedge rst)
begin
  if (!rst)
  begin
    currentPC = 0;
	 instruction = 16'b0000100000000000; // nop
	 rs = 0;
	 rm = 0;
  end
  else
  begin
    currentPC = currentPCIn;
	 instruction = instructionIn;
	 rs = rsIn;
	 rm = rmIn;
  end
end

always @(posedge clk or negedge rst)
begin
  t_written = 1;
  t = 0;
  res = 0;
  if (!rst) // the negedge of rst
  begin
    t_written = 1;
    t = 0;
    res = 0;
  end
  else
  begin
    case (instruction[15:11])
      5'b00000:                         // addsp3
        res = rs + imm16s;
      //5'b00001:                         // nop
      //5'b00010:                         // b
      //5'b00100:                         // beqz
      //5'b00101:                         // bnez
      5'b00110:                         // sll, srl, sra
        case (instruction[1:0])
          2'b00:   res = rs << shift_imm4;  // sll
          2'b10:   res = rs >> shift_imm4;  // srl
          2'b11:   res = rs >>> shift_imm4; // sra
        endcase
      5'b01000:                         // addiu3
        res = rs + imm16from4s;
      5'b01001:                         // addiu
        res = rs + imm16s;
      5'b01010:                         // slti
      begin
        t_written = 0;
        t = $signed(rs) < imm16s;
      end
      5'b01100:                         // addsp, bteqz, btnez, mtsp, sw_rs
        case (instruction[10:8])
          //3'b000:                       // bteqz
          //3'b001:                       // btnez
          3'b010:                       // sw_rs
            res = rs;
          3'b011:                       // addsp
            res = rs + imm16s;
          3'b100:                       // mtsp
            res = rs;
        endcase
      5'b01011:                         // sltui
      begin
        t_written = 0;
        t = rs < rm;
      end
      5'b01101:                         // li
        res = imm16;
      5'b01110:                         // cmpi
      begin
        t_written = 1;
        t = rs != imm16s;
      end
      5'b01111:                         // move
        res = rs;
      //5'b10010:                         // lw_sp
      //5'b10011:                         // lw
      5'b11010:                         // sw_sp
        res = rs;
      5'b11011:                         // sw
        res = rs;
      5'b11100:                         // addu, subu
        case (instruction[1:0])
          2'b01:   res = rs + rm;           // addu
          2'b11:   res = rs - rm;           // subu
        endcase
      5'b11101:                         // jalr, jr, jrra, mfpc, sllv, srav, slt, sltu, srlv, cmp, neg, and, or, xor, not
        case (instruction[4:0])
          5'b00000:                     // jalr, jr, jrra, mfpc
            case (instruction[7:5])
              //3'b000:                   // jr
              //3'b001:                   // jrra
              3'b010:                   // mfpc
                res = currentPC;
              3'b110:                   // jalr
                res = currentPC;
            endcase
          5'b00010:                     // slt
          begin
            t_written = 0;
            t = $signed(rs) < $signed(rm);
          end
          5'b00011:                     // sltu
          begin
            t_written = 0;
            t = $unsigned(rs) < $unsigned(rm);
          end
          5'b00100:                     // sllv
            res = rs << rm;
          5'b00110:                     // srlv
            res = rs >> rm;
          5'b00111:                     // srav
            res = rs >>> rm;
          5'b01010:                     // cmp
          begin
            t_written = 0;
            t = rs != rm;
          end
          5'b01011:                     // neg
            res = - rs;
          5'b01100:                     // and
            res = rs & rm;
          5'b01101:                     // or
            res = rs | rm;
          5'b01110:                     // xor
            res = rs ^ rm;
          5'b01111:                     // not
            res = ~ rs;
        endcase
      5'b11110:                         // mfih, mtih
        case (instruction[0])
          1'b0:                         // mfih
            res = rs;
          1'b1:                         // mtih
            res = rs;
        endcase
      //5'b11111:                         // int
    endcase
  end
//  case (instruction[15:11])
//    5'b00110:                             // sll, sra, srl
//      case (instruction[1:0])
//        2'b00:   res = rs << shift_imm4;  // sll
//        2'b10:   res = rs >> shift_imm4;  // srl
//        2'b11:   res = rs >>> shift_imm4; // sra
//      endcase
//    5'b01001:                             // addiu
//      res = rs + imm16s;
//    5'b01010: begin                       // slti
//      t_written = 1;
//      t = $signed(rs) < imm16s;
//    end
//    5'b01011: begin                       // sltui
//      t_written = 1;
//      t = rs < rm;
//    end
//    5'b01110: begin                       // cmpi
//      t_written = 1;
//      t = rs != imm16s;
//    end
//    5'b11100:                             // addu, subu
//      case (instruction[1:0])
//        2'b01:   res = rs + rm;           // addu
//        2'b11:   res = rs - rm;           // subu
//      endcase
//    5'b11101:                             // too many to enumerate
//      casex (instruction[4:0])
//        5'b00010: begin                   // slt
//          t_written = 1;
//          t = $signed(rs) < $signed(rm);
//        end
//        5'b00011: begin                   // sltu
//          t_written = 1;
//          t = rs < rm;
//        end
//        5'b00100: res = rs << rm;         // sllv
//        5'b00110: res = rs >> rm;         // srlv
//        5'b00111: res = rs >>> rm;        // srav
//        5'b01010: begin                   // cmp
//          t_written = 1;
//          t = rs != rm;
//        end
//        5'b01011: res = - rm;             // neg
//        5'b01100: res = rs & rm;          // and
//        5'b01101: res = rs | rm;          // or
//        5'b01110: res = rs ^ rm;          // xor
//        5'b01111: res = ~ rs;             // not
//      endcase
//  endcase
end

endmodule
