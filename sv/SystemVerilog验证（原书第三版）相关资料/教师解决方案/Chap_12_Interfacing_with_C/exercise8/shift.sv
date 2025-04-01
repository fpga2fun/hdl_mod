//////////////////////////////////////////////////////////////////////////
// Purpose: SystemVerilog module for Chap_12_Interfacing_with_C/exercise8
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: shift.sv,v $
// Revision 1.1  2011/09/27 17:23:22  tumbush.tumbush
// Initial check-in
//
//
//////////////////////////////////////////////////////////////////////////
module shift;
   import "DPI-C" context function int shift_c(input bit [31:0] i, input int n);
      export "DPI-C" function shift_sv; // no args or return value

      reg [31:0] val;
      int 	 shift;
      reg [31:0] shifted;
      
    initial begin
	 val = 1; shift = 1;
	 shifted = shift_c(val, shift);
	 $display("0d%0d shifted by 0d%0d = 0d%0d", val, shift, shifted);

	 val = 2; shift = -1;
	 shifted = shift_c(val, shift);
	 $display("0d%0d shifted by 0d%0d = 0d%0d", val, shift, shifted);

	 val = 2; shift = 0;
	 shifted = shift_c(val, shift);
	 $display("0d%0d shifted by 0d%0d = 0d%0d", val, shift, shifted);
	 
         $finish; 
    end // initial begin

// A positive value on n means to left shift i (multiply)
// A negative value on n means to right shift i (divide)
// n=0 means to return i
   function int shift_sv(input bit [31:0] i, input int n);
      if (n < 0)
	shift_sv = (i >> (n *-1));
      else if (n > 0)
	shift_sv = (i << n);
      else
	shift_sv = i;
   endfunction // shift_sv
   

endmodule
