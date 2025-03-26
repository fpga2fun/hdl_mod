////////////////////////////////////////////////////////////////////////////
// Purpose: SystemVerilog code for Chap_2_Data_Types/exercise4
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/28 19:48:08  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/03 23:26:15  Greg
// Initial check-in
//
///////////////////////////////////////////////////////////////////////////
`default_nettype none
module test;
   logic my_array1[5] [31];

initial begin
   my_array1[4][30] = 1'b1;
   my_array1[29][4] = 1'b1;
   // my_array1[3] = 32'b0; // # ** Error: test.sv(8): Cannot assign a packed type to an unpacked type

   for (int i=0;i<=4;i++) begin
      $write("my_array1[%0d]=", i);
      for (int j=30;j>=0;j--) begin
	 $writeb(my_array1[i][j]);
      end
      $display; // newline
   end
   
   $finish;

end
   
endmodule // test

