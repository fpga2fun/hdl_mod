////////////////////////////////////////////////////////////////////////////
// Purpose: SystemVerilog code for Chap_2_Data_Types/exercise5
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/28 19:48:09  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/04 17:30:45  Greg
// Initial check-in
//
///////////////////////////////////////////////////////////////////////////
`default_nettype none
module test;

   bit [4:0] [30:0]  my_array2; 
      
   initial begin
      my_array2[4][30] = 1'b1;
      my_array2[29][4] = 1'b1;
      my_array2[3] = 32'b1;
      
      for (int i=4;i>=0;i--) begin
	 $displayb("my_array2[%0d]=%b", i, my_array2[i]);
      end

      $finish;
      
   end

endmodule // test

