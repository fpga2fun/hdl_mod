//////////////////////////////////////////////////////////////////////////////////////////
// Purpose: Program that declares handles for each test.
//          Chap_8_Advanced_OOP_and_Testbench_Guidelines/homework_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/29 19:16:11  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/29 19:28:37  Greg
// Initial check-in
//
//////////////////////////////////////////////////////////////////////////////////////////

`default_nettype none
  program automatic test;

   import my_package::*;
   import test_pkg::*;
   import scoreboard_pkg::*;

   TestBase tb;
   initial begin
      // List each test
      TestGood TestGood_handle = new();
      Test_v3  Test_v3_handle = new();
      TestBad TestBad_handle = new();
      $timeformat(-9, 0, "ns", 0);
      tb = TestRegistry::get_test();
      tb.run_test();
   end

   final
     $display("%0t: Compared 0d%0d packets", $time, tb.env.scb.num_compared);


endprogram
