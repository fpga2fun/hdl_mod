//////////////////////////////////////////////////////////////////////////
// Purpose: SystemVerilog module for Chap_12_Interfacing_with_C/exercise2
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: shift.sv,v $
// Revision 1.3  2011/09/24 20:20:26  tumbush.tumbush
// Initial check-in
//
//
//////////////////////////////////////////////////////////////////////////
module shift;
   import "DPI-C" context function int shift_c(input bit[31:0] i, input int n, input bit ld);

      reg [31:0] val;
      int 	 shift;
      reg [31:0] shifted;
      reg 	 load;
      
    initial
      begin
	 // Test loading which will produce the same results as exercise 1
	 $display("loading");
	 val = 1; shift = 1; load = 1;
	 shifted = shift_c(val, shift, load);
	 $display("0d%0d shifted by 0d%0d = 0d%0d", val, shift, shifted);

	 val = 2; shift = -1; load = 1;
	 shifted = shift_c(val, shift, load);
	 $display("0d%0d shifted by 0d%0d = 0d%0d", val, shift, shifted);

	 val = 2; shift = 0; load = 1;
	 shifted = shift_c(val, shift, load);
	 $display("0d%0d shifted by 0d%0d = 0d%0d", val, shift, shifted);

	 // Test not loading which will ignore i and operate on the internal register
	 // At this point internal_reg = 2
	 $display("Not loading");
	 val = 255; shift = 2; load = 0;
	 shifted = shift_c(val, shift, load); // shifted should equal 8
	 $display("0d%0d shifted by 0d%0d = 0d%0d", val, shift, shifted);

	 val = 1023; shift = -1; load = 0;
	 shifted = shift_c(val, shift, load); // shifted should equal 4
	 $display("0d%0d shifted by 0d%0d = 0d%0d", val, shift, shifted);

	 val = 2047; shift = 0; load = 0;
	 shifted = shift_c(val, shift, load); // shifted should equal 4
	 $display("0d%0d shifted by 0d%0d = 0d%0d", val, shift, shifted);
        
	 
         $finish;

	 
     end


endmodule
