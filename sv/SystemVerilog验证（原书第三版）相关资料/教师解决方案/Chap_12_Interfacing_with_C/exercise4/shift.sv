//////////////////////////////////////////////////////////////////////////
// Purpose: SystemVerilog module for Chap_12_Interfacing_with_C/exercise4
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: shift.sv,v $
// Revision 1.1  2011/09/27 17:10:17  tumbush.tumbush
// Initial check-in
//
//
//
//////////////////////////////////////////////////////////////////////////
module shift;
   import "DPI-C" function chandle shift_new();
   import "DPI-C" context function int shift_c(input bit[31:0] i, input int n, input bit ld, input chandle inst);

      reg [31:0] val;
      int 	 shift;
      reg [31:0] shifted;
      reg 	 load;
      
    initial begin
	 
         chandle 	inst1, inst2; // Points to storage in C
         inst1 = shift_new();
         inst2 = shift_new();
       
	 $display("loading");
         val = 1; shift = 1; load = 1;
	 shifted = shift_c(val, shift, load, inst1); // shifted = 2

	 val = 2; shift = -1; load = 1; 
	 shifted = shift_c(val, shift, load, inst2); // Shifted = 1

	 val = 2; shift = 0; load = 1;
	 shifted = shift_c(val, shift, load, inst1); // Shifted = 2

	 val = 2; shift = 2; load = 1;
	 shifted = shift_c(val, shift, load, inst2); // Shifted = 8

         // Set load = 0 and shift.
         // For inst1 internal_reg = 2
         // For inst2 internal_reg = 8      
	 $display("Not loading");
         val = 255; shift = 1; load = 0; // Shifted = 4
	 shifted = shift_c(val, shift, load, inst1); 

	 val = 511; shift = -3; load = 0; // Shifted = 1
	 shifted = shift_c(val, shift, load, inst2);

	 val = 1023; shift = 0; load = 0; // shifted = 4
	 shifted = shift_c(val, shift, load, inst1);

	 val = 2047; shift = 1; load = 0; // shifted = 2
	 shifted = shift_c(val, shift, load, inst2);
        	 
         $finish;
	 
     end


endmodule
