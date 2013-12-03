module interrupt (
  input clk, rst,
  input [15:0] currentPCIn,
  input interruptSignal,
  input [3:0] interruptIndex,
  input eret,
  output reg interruptOccurs,
  output reg [15:0] interruptPC
);

reg [15:0] currentPC, returnPC;
reg interruptEnable;
reg clear;

always @ (negedge clk or negedge rst)
  if (!rst)
  begin
    currentPC = 0;
	 clear = 1;
  end
  else
  begin
    currentPC = currentPCIn;
	 clear = interruptOccurs;
  end

always @ (clk or rst or eret or interruptSignal or interruptIndex)
//always @ (posedge clk or negedge rst)
begin
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
		  else if (!clear)
		    interruptOccurs = 1;
      end
    end
end

endmodule
