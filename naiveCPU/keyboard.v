module keyboard (
  input clk, rst,
  input keyDown,
  input [15:0] inputValue,
  output reg interruptSignal,
  output reg [3:0] interruptIndex,
  output [15:0] data
);

reg [31:0] delay;

assign data = inputValue;

always @ (posedge clk or negedge rst)
  if (!rst)
    delay = 0;
  else
  begin
    if (delay == 1000000)
      delay = 0;
    else
      delay = delay + 1;
  end

always @ (posedge clk or negedge rst)
  if (!rst)
  begin
    interruptSignal = 1;
    interruptIndex = 0;
  end
  else
  begin
//    if (delay == 0)
    begin
      interruptSignal = keyDown;
      interruptIndex = 1;
    end
//    else
//    begin
//      interruptSignal = 1;
//      interruptIndex = 0;
//    end
  end

endmodule
