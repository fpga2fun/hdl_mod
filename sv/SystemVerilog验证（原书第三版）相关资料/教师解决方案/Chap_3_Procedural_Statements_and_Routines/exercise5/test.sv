////////////////////////////////////////////////////////////////////////////
// Purpose: Solution for Chap_3_Procedural_Statements_and_Routines/exercise5
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/28 20:06:47  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/08 20:49:19  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////////////////////
`default_nettype none
  module test;
   timeunit 1ns;
   timeprecision 1ps;


   parameter real t_real = 5.5;
   parameter time t_time = 5ns;

   
   
   initial begin
      // Specify that the time should be printed in ps, 2 places to the
      // right of the decimal point and use as few chars as possible
      #t_time $display("1 %t", $realtime); // 5000.00ps
      #t_real $display("1 %t", $realtime); // 10500.00ps
      #t_time $display("1 %t", $realtime); // 15500.00ps
      #t_real $display("1 %t", $realtime); // 21000.00ps
   end

   initial begin
      $timeformat(-12, 2, "ps", 10); 
      #t_time $display("2 %t", $time); // 5000.00ps 
      #t_real $display("2 %t", $time); // 11000.00ps
      #t_time $display("2 %t", $time); // 16000.00ps
      #t_real $display("2 %t", $time); // 21000.00ps
   end

   initial begin
      #22ns;
      $finish;
   end

endmodule // test

