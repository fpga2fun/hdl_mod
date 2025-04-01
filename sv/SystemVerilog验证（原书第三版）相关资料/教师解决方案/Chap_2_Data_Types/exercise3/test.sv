////////////////////////////////////////////////////////////////////////////
// Purpose: SystemVerilog code for Chap_2_Data_Types/exercise3
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/28 19:48:07  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.2  2011/05/19 18:32:24  Greg
// Changed display statements to be more meaningful
//
// Revision 1.1  2011/05/03 23:20:48  Greg
// Initial check-in
//
///////////////////////////////////////////////////////////////////////////

`default_nettype none
module test;
   bit [11:0] my_array[4]; 
      
initial begin
  my_array = '{12'h012, 12'h345, 12'h678, 12'h9AB};

   for (int i=0;i<$size(my_array); i++) begin
      $display("my_array[%0d]=12'b%b", i, my_array[i]);
   end
   
   $display("--------------");

   for (int i=0;i<$size(my_array); i++) begin
      $display("my_array[%0d][5:4]=%b", i, my_array[i][5:4]);
   end   

   $display("--------------");

   foreach (my_array[i]) begin
      $display("my_array[%0d][5:4]=%b", i, my_array[i][5:4]);
   end

   $finish;

end
   
endmodule // test

