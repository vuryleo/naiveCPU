module interrupt (
  input clk, rst,
  input [15:0] currentPCIn,
  input interruptSignal,
  input [3:0] interruptIndex,
  input eret,
  output reg interruptOccurs,
  output reg [15:0] interruptPC
);

reg interruptEnable;
reg [15:0] currentPC, returnPC;

always @ (negedge clk or negedge rst)
  if (!rst)
    currentPC = 0;
  else
    currentPC = currentPCIn;

always @ (*)
begin
  interruptOccurs = 1;
  if (!rst)
  begin
    interruptOccurs = 1;
    interruptPC = 0;
    returnPC = 0;
    interruptEnable = 0;
  end
  else
  begin
    if (!eret) // it returned
    begin
      interruptOccurs = 0;
      interruptEnable = 0;
      interruptPC = returnPC;
    end
    else
    begin
      if (!interruptSignal && !interruptEnable)
      begin
        interruptOccurs = 0;
        interruptPC = {12'h000, interruptIndex * 4};
        returnPC = currentPC;
        interruptEnable = 1;
      end
    end
  end
end

endmodule
