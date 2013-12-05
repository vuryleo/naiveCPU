module interrupt (
  input clk, rst,
  input [15:0] currentPCIn, currentIRIn,
  input interruptSignal,
  input [3:0] interruptIndex,
  input eret,
  output reg interruptOccurs,
  output reg [15:0] interruptPC,
  output reg [15:0] interruptIR
);

reg [15:0] currentPC, returnPC, currentIR, returnIR;
reg interruptEnable;
reg clear;

always @ (negedge clk or negedge rst)
  if (!rst)
  begin
    currentPC = 0;
    clear = 1;
    currentIR = 16'h0800; // nop
  end
  else
  begin
    currentPC = currentPCIn;
    clear = interruptOccurs;
    currentIR = currentIRIn;
  end

//always @ (clk or rst or eret or interruptSignal or interruptIndex)
//always @ (posedge clk or negedge rst)
always @ (*)
begin
  if (!rst)
  begin
    interruptOccurs = 1;
    interruptPC = 0;
	 interruptIR = 16'h0800;
    returnPC = 0;
    returnIR = 16'h0800; // nop
    interruptEnable = 0;
  end
  else
    begin
      if (!eret) // it returned
      begin
        interruptOccurs = 0;
        interruptEnable = 0;
        interruptPC = returnPC;
	     interruptIR = returnIR;
      end
      else
      begin
        if (!interruptSignal && !interruptEnable)
        begin
          interruptOccurs = 0;
          interruptPC = {12'h000, interruptIndex * 4};
			 interruptIR = 16'h0800;
          returnPC = currentPC;
			 returnIR = currentIR;
          interruptEnable = 1;
        end
        else if (!clear)
        begin
          interruptOccurs = 1;
        end
      end
    end
end

endmodule
