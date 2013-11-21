`ifndef _alu_v
`define _alu_v

/* only consider R-type or I-type instructions
 * nop, sw*, lw*, *sp, b*, j* are not handled
 */
module alu(input[15:0] rx, ry, input[15:0] instruction, output reg[15:0] res, output reg t_written, t);
  wire[15:0] imm16 = {8'd0, instruction[7:0]};
  wire[15:0] imm16s = {instruction[7] ? 8'hff : 8'h00, instruction[7:0]};
  wire[3:0] shift_imm4 = instruction[4:2] ? instruction[4:2] : 8;

  always @* begin
    t_written = 0;
    t = 0;
    res = 0;
    case (instruction[15:11])
      5'b00110:                             // sll, sra, srl
        case (instruction[1:0])
          2'b00:   res = rx << shift_imm4;  // sll
          2'b10:   res = rx >> shift_imm4;  // srl
          2'b11:   res = rx >>> shift_imm4; // sra
        endcase
      5'b01001:                             // addiu
        res = rx + imm16s;
      5'b01010: begin                       // slti
        t_written = 1;
        t = $signed(rx) < imm16s;
      end
      5'b01011: begin                       // sltui
        t_written = 1;
        t = rx < ry;
      end
      5'b01110: begin                       // cmpi
        t_written = 1;
        t = rx != imm16s;
      end
      5'b11100:                             // addu, subu
        case (instruction[1:0])
          2'b01:   res = rx + ry;           // addu
          2'b11:   res = rx - ry;           // subu
        endcase
      5'b11101:                             // too many to enumerate
        casex (instruction[4:0])
          5'b00010: begin                   // slt
            t_written = 1;
            t = $signed(rx) < $signed(ry);
          end
          5'b00011: begin                   // sltu
            t_written = 1;
            t = rx < ry;
          end
          5'b00100: res = rx << ry;         // sllv
          5'b00110: res = rx >> ry;         // srlv
          5'b00111: res = rx >>> ry;        // srav
          5'b01010: begin                   // cmp
            t_written = 1;
            t = rx != ry;
          end
          5'b01011: res = - ry;             // neg
          5'b01100: res = rx & ry;          // and
          5'b01101: res = rx | ry;          // or
          5'b01110: res = rx ^ ry;          // xor
          5'b01111: res = ~ rx;             // not
        endcase
    endcase
  end
endmodule

`endif // include guard
