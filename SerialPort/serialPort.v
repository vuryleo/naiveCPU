module serial_port(
  input clk, rst,              // clk & rst
    tbre, tsre, data_ready,    // wires linked with CPLD
  input [1:0] mode,            // toggle switch controlling whether to read or write or synthesize
  input [7:0] data_to_send,    // toggle switches controlling data to send to serial port
  inout [7:0] ram1_data,       // bus
  output reg rdn, wrn,
  output ram1_oe, ram1_we, ram1_en,
  output reg [7:0] led,         // LED displays data received by serial port
  output [7:0] leddebug
);

  localparam MODE_WRITE = 2'b00;
  localparam MODE_READ = 2'b01;
  localparam MODE_SYNTHESIS = 2'b10;

  reg [2:0] state, next_state;
  reg bus_written;
  reg [7:0] recv_val;

  assign ram1_data = bus_written ? (mode == MODE_WRITE ? data_to_send : recv_val) : 8'bzzzzzzzz;
  assign ram1_oe = 1;
  assign ram1_we = 1;
  assign ram1_en = 1;

  always @(negedge clk or negedge rst) begin
    if (!rst)
      state <= 0;
    else
      state <= next_state;
  end
  assign leddebug = {recv_val[4:0], state};

  always @(mode, state, led) begin
    if (mode == MODE_SYNTHESIS && state == 2)
      recv_val = led + 1;
  end

  always @(state, data_ready, tbre, tsre) begin
    bus_written = 0;
    led = 0;
    case (mode)
      MODE_WRITE: begin
        case (state)
          0: begin
            rdn = 1;
            wrn = 0;
            next_state = 1;
            bus_written = 1;
          end
          1: begin
            rdn = 1;
            next_state = 2;
            wrn = 1;
          end
          2: begin
            rdn = 1;
            wrn = 1;
            next_state = tbre ? 3 : 2;
          end
          default: begin
            rdn = 1;
            wrn = 1;
            next_state = tsre ? 0 : 3;
          end
        endcase
      end
      MODE_READ:
        case (state)
          0: begin
            next_state = 1;
            rdn = 1;
            wrn = 1;
          end
          1: begin
            next_state = data_ready ? 2 : 1;
            rdn = 1;
            wrn = 1;
          end
          default: begin
            next_state = 0;
            wrn = 1;
            rdn = 0;
            led = ram1_data;
          end
        endcase

      MODE_SYNTHESIS:
        case (state)
          // read phase
          0: begin
            next_state = 1;
            rdn = 1;
            wrn = 1;
          end
          1: begin
            next_state = data_ready ? 2 : 1;
            rdn = 1;
            wrn = 1;
          end
          2: begin
            next_state = 3;
            wrn = 1;
            rdn = 0;
            led = ram1_data;
          end

          // write phase
          3: begin
            rdn = 1;
            wrn = 1;
            next_state = 4;
          end
          4: begin
            rdn = 1;
            wrn = 0;
            next_state = 5;
            bus_written = 1;
          end
          5: begin
            rdn = 1;
            next_state = 6;
            wrn = 1;
          end
          6: begin
            rdn = 1;
            wrn = 1;
            next_state = tbre ? 7 : 6;
          end
          default: begin
            rdn = 1;
            wrn = 1;
            next_state = tsre ? 0 : 7;
          end
        endcase
    endcase
  end
endmodule
