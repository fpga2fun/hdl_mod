///////////////////////////////////////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_8_Advanced_OOP_and_Testbench_Guidelines/exercise9_10
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/29 19:16:10  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/11 22:59:00  Greg
// Initial check-in
//
///////////////////////////////////////////////////////////////////////////////////////////
`default_nettype none
  program automatic test;

   import my_package::*;

   // comparator #(bit [3:0]) compare_4bit;
   // or
   comparator compare_4bit;
   comparator #(color) compare_color;
   bit [3:0] expected_4bit = 4'h4, actual_4bit = 4'h3;
   color expected_color = RED, actual_color = RED;
   int error = 0;
   
   initial begin
      compare_4bit = new();
      compare_color = new();
      if (!(compare_4bit.compare(expected_4bit, actual_4bit))) error++;
      if (!(compare_color.compare(expected_color, actual_color))) error++;
      $display("error = %0d", error);
   end
   

endprogram
