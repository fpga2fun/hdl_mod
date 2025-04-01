//////////////////////////////////////////////////////////////////////////
// Purpose: SystemVerilog module for Chap_12_Interfacing_with_C/exercise1
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: shift.sv,v $
// Revision 1.3  2011/09/24 20:31:51  tumbush.tumbush
// Pass in [31:0] as const svBitVecVal
//
// Revision 1.2  2011/09/23 21:20:31  tumbush.tumbush
// Updated names in C code function.
//
// Revision 1.1  2011/09/20 16:44:00  tumbush.tumbush
// Initial check-in.
//
//
//////////////////////////////////////////////////////////////////////////
module shift;
   import "DPI-C" context function int shift_c(input bit [31:0] i, input int n);

      reg [31:0] val;
      int 	 shift;
      reg [31:0] shifted;
      
    initial
      begin
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

	 
     end


endmodule
