//////////////////////////////////////////////////////////////////////////
// Purpose: SystemVerilog module for Chap_12_Interfacing_with_C/exercise6
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: shift.sv,v $
// Revision 1.2  2011/09/27 18:40:40  tumbush.tumbush
// Enhanced information displayed.
//
// Revision 1.1  2011/09/27 17:18:00  tumbush.tumbush
// Initial check-in
//
//
//////////////////////////////////////////////////////////////////////////
module shift;
   import "DPI-C" function chandle shift_new(int);
   import "DPI-C" context function int shift_c(input bit[31:0] i, input int n, input bit ld, input chandle inst);

      reg [31:0] val;
      int 	 shift;
      reg [31:0] shifted;
      reg 	 load;
      
    initial begin
	 
         chandle 	inst1, inst2; // Points to storage in C
         inst1 = shift_new(512);
         inst2 = shift_new(2048);

         $display("Instance address %0d: initialized internal_reg to %0d", int'(inst1), 512);
         $display("Instance address %0d: initialized internal_reg to %0d", int'(inst2), 2048);
       

         // Set load = 0 and shift.
	 $display("Not loading");
         val = 1; shift = 1; load = 0; // Shifted = 1024
	 shifted = shift_c(val, shift, load, inst1); 

	 val = 2; shift = -3; load = 0; // Shifted = 256
	 shifted = shift_c(val, shift, load, inst2);

	 val = 3; shift = 0; load = 0; // shifted = 1024
	 shifted = shift_c(val, shift, load, inst1);

	 val = 4; shift = 1; load = 0; // shifted = 512
	 shifted = shift_c(val, shift, load, inst2);
        	 
         $finish;
	 
     end


endmodule
