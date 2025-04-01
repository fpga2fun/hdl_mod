////////////////////////////////////////////////////////////////////////////
// Purpose: SystemVerilog code for Chap_2_Data_Types/exercise7
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.2  2011/08/25 18:59:43  tumbush.tumbush
// ISR is at (2^20)-1 = 'hF_FFFF
//
// Revision 1.1  2011/05/28 19:48:12  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/04 17:37:41  Greg
// Initial check-in
//
///////////////////////////////////////////////////////////////////////////
`default_nettype none
  module test;
   
   bit [23:0] assoc[int];

initial begin

   assoc[0]        = 24'hA51000; // Jump to location 0x400 for the main code
   assoc[32'h400]  = 24'h123456; // Instruction 1
   assoc[32'h401]  = 24'h789ABC; // Instruction 2
   assoc[32'hF_FFFF] = 24'h0F1E2D; // Return from interrupt ((2^20)-1)='hF_FFFF

   $display("The # of entries is %0d", assoc.num);
   
   foreach (assoc[i]) begin
       $display("assoc[%h] = %h", i, assoc[i]);
   end

   $finish;
end

endmodule // test

