module instructionDecoder (
  input clk, rst,
  input [15:0] instruction,
  output reg [3:0] registerS, registerM, registerT,
  output reg [1:0] memControl
);

always @ (negedge clk or negedge rst)
begin
  registerS = 0;
  registerM = 0;
  registerT = 0;
  memControl = 2'b00; // IDLE
  if (!rst) // the negedge of rst
  begin
    registerS = 0;
    registerM = 0;
    registerT = 0;
  end
  else
  begin
    case (instruction[15:11])
      5'b00000:                         // addsp3
      begin
        registerS = 4'b1001;            // sp
        registerT = instruction[10:8];
      end
      //5'b00001:                         // nop
      //5'b00010:                         // b
      5'b00100:                         // beqz
        registerS = instruction[10:8];
      5'b00101:                         // bnez
        registerS = instruction[10:8];
      5'b00110:                         // sll, srl, sra
      begin
        registerS = instruction[7:5];
        registerT = instruction[10:8];
      end
      5'b01000:                         // addiu3
      begin
        registerS = instruction[10:8];
        registerT = instruction[7:5];
      end
      5'b01001:                         // addiu
      begin
        registerS = instruction[10:8];
        registerT = instruction[10:8];
      end
      5'b01010:                         // slti
        registerS = instruction[10:8];
      5'b01100:                         // addsp, bteqz, btnez, mtsp, sw_rs
        case (instruction[10:8])
          //3'b000:                       // bteqz
          //3'b001:                       // btnez
          3'b010:                       // sw_rs
          begin
            registerS = 4'b1010;
            registerM = 4'b1001;
          end
          3'b011:                       // addsp
          begin
            registerS = 4'b1001;        // sp
            registerT = 4'b1001;        // sp
          end
          3'b100:                       // mtsp
          begin
            registerS = instruction[7:5];
            registerT = 4'b1001;        // sp
          end
        endcase
      5'b01011:                         // sltui
        registerS = instruction[10:8];
      5'b01101:                         // li
        registerT = instruction[10:8];
      5'b01110:                         // cmpi
        registerS = instruction[10:8];
      5'b01111:                         // move
      begin
        registerS = instruction[7:5];
        registerT = instruction[10:8];
      end
      5'b10010:                         // lw_sp
      begin
        registerS = 4'b1001;            // sp
        registerT = instruction[10:8];
      end
      5'b10011:                         // lw
      begin
        registerS = instruction[10:8];
        registerT = instruction[7:5];
      end
      5'b11010:                         // sw_sp
      begin
        registerS = 4'b1001;            // sp
        registerM = instruction[10:8];
      end
      5'b11011:                         // sw
      begin
        registerS = instruction[7:5];
        registerM = instruction[10:8];
      end
      5'b11100:                         // addu, subu
      begin
        registerS = instruction[10:8];
        registerM = instruction[7:5];
        registerT = instruction[4:2];
      end
      5'b11101:                         // jalr, jr, jrra, mfpc, sllv, srav, slt, sltu, srlv, cmp, neg, and, or, xor, not
        case (instruction[4:0])
          5'b00000:                     // jalr, jr, jrra, mfpc
            case (instruction[7:5])
              3'b000:                   // jr
                registerS = instruction[10:8];
              //3'b001:                   // jrra
              3'b010:                   // mfpc
                registerT = instruction[10:8];
              3'b110:                   // jalr
              begin
                registerS = instruction[10:8];
                registerT = 4'b1010;    // ra
              end
            endcase
          5'b00010:                     // slt
          begin
            registerS = instruction[10:8];
            registerM = instruction[7:5];
          end
          5'b00011:                     // sltu
          begin
            registerS = instruction[10:8];
            registerM = instruction[7:5];
          end
          5'b00100:                     // sllv
          begin
            registerS = instruction[7:5];
            registerM = instruction[10:8];
            registerT = instruction[7:5];
          end
          5'b00110:                     // srlv
          begin
            registerS = instruction[7:5];
            registerM = instruction[10:8];
            registerT = instruction[7:5];
          end
          5'b00111:                     // srav
          begin
            registerS = instruction[7:5];
            registerM = instruction[10:8];
            registerT = instruction[7:5];
          end
          5'b01010:                     // cmp
          begin
            registerS = instruction[7:5];
            registerM = instruction[10:8];
          end
          5'b01011:                     // neg
          begin
            registerS = instruction[7:5];
            registerT = instruction[10:8];
          end
          5'b01100:                     // and
          begin
            registerS = instruction[7:5];
            registerM = instruction[10:8];
            registerT = instruction[10:8];
          end
          5'b01101:                     // or
          begin
            registerS = instruction[7:5];
            registerM = instruction[10:8];
            registerT = instruction[10:8];
          end
          5'b01110:                     // xor
          begin
            registerS = instruction[7:5];
            registerM = instruction[10:8];
            registerT = instruction[10:8];
          end
          5'b01111:                     // not
          begin
            registerS = instruction[7:5];
            registerT = instruction[10:8];
          end
        endcase
      5'b11110:                         // mfih, mtih
        case (instruction[0])
          1'b0:                         // mfih
          begin
            registerS = 4'b1000;        // ih
            registerT = instruction[10:8];
          end
          1'b1:                         // mtih
          begin
            registerS = instruction[10:8];
            registerT = 4'b1000;        // ih
          end
        endcase
      //5'b11111:                         // int
    endcase
  end
end

endmodule

