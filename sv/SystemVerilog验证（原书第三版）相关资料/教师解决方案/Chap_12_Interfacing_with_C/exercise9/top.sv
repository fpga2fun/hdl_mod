//////////////////////////////////////////////////////////////////////////
// Purpose: SystemVerilog module for Chap_12_Interfacing_with_C/exercise9
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: top.sv,v $
// Revision 1.3  2011/09/27 19:20:29  tumbush.tumbush
// Initial check-in
//
//
//////////////////////////////////////////////////////////////////////////
module top;
      reg [31:0] val;
   int 	      shift;
   reg [31:0] shifted;

   shift shift();
   
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
endmodule
