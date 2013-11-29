module byPass (
  input [3:0] sourceIndex,
  input [15:0] sourceValue,
  input [3:0] updateIndex,
  input [15:0] updateValue,
  output [15:0] selectedValue
);

assign selectedValue = updateIndex == sourceIndex? updateValue : sourceValue;

endmodule