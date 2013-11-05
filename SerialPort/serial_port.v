module serial_port(
  input clk, rst,              // clk & rst
    tbre, tsre, data_ready,    // wires linked with CPLD
  input [1:0] mode,            // toggle switch controlling whether to read or write or synthesize
  input [7:0] data_to_send,    // toggle switches controlling data to send to serial port
  inout [7:0] ram1_data,       // bus
  output reg ram1_oe, ram1_we, ram1_en,
  output reg [7:0] led         // LED displays data received by serial port
);

  localparam MODE_WRITE = 2'b00;
  localparam MODE_READ = 2'b01;
  localparam MODE_SYNTHESIS = 2'b10;

  reg [1:0] state, next_state;
  reg [7:0] bus;
  reg rdn, wrn;
  reg bus_written;

  assign ram1_data = bus_written ? bus : 8'bzzzzzzzz;

  always @(negedge clk, negedge rst) begin
    if (! rst) begin
      state <= 0;
      rdn <= 1;
      wrn <= 1;

      bus <= 8'bzzzzzzzz;
      ram1_oe <= 1;
      ram1_we <= 1;
      ram1_en <= 1;
    end else if (! clk)
      state <= next_state;
  end

  always @* begin
    bus_written = 0;
    case (mode)
      MODE_WRITE:
        case (state)
          0: begin
            next_state = 1;
            wrn = 1;
            bus_written = 1;
            bus = data_to_send;
          end
          1: begin
            next_state = 2;
            wrn = 0;
          end
          default:
            next_state = tsre ? 0 : 2;
        endcase

      MODE_READ:
        case (state)
          0: begin
            next_state = 1;
            bus = 8'bzzzzzzzz;
            rdn = 1;
          end
          1: begin
            next_state = data_ready ? 2 : 0;
            rdn = 0;
          end
          default: begin
            next_state = 0;
            led = ram1_data;
          end
        endcase

      MODE_SYNTHESIS:
        case (state)
          // read phase
          0: begin
            next_state = 1;
            bus = 8'bzzzzzzzz;
            rdn = 1;
          end
          1: begin
            next_state = data_ready ? 2 : 0;
            rdn = 0;
          end
          2: begin
            next_state = 3;
            led = ram1_data;
          end

          // write phase
          3: begin
            next_state = 4;
            wrn = 1;
            bus_written = 1;
          end
          4: begin
            next_state = 5;
            wrn = 0;
          end
          default: begin
            next_state = tsre ? 0 : 5;
          end
        endcase
    endcase
  end

endmodule
