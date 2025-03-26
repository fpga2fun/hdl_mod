////////////////////////////////////////////////////////////////////////////
// Purpose: Solution for Chap_3_Procedural_Statements_and_Routines/exercise3
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/28 20:06:45  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/08 20:40:33  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////////////////////
`default_nettype none
module test;

   int new_address1, new_address2;
   bit clk;

   initial begin
      fork
	 my_task2(21, new_address1);
	 my_task2(20, new_address2);
      join
      $display("new_address1 = %0d", new_address1);
      $display("new_address2 = %0d", new_address2);
      $finish;
   end

   initial begin
      clk = 0;
      forever clk=#50 !clk;
   end
   
   task my_task2(input int address, output int new_address);
     $display("Called my_task2 with input address = %0d", address);
       @(clk);
      new_address = address;
   endtask // my_task2
   
endmodule // test

