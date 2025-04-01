/////////////////////////////////////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_7_Threads_and_Interprocess_Communication/homework1_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.2  2011/09/08 22:46:42  tumbush.tumbush
// Use SV_RAND_CHECK instead of assert
//
// Revision 1.1  2011/05/29 19:13:48  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/18 20:10:32  Greg
// Initial checkin
//
/////////////////////////////////////////////////////////////////////////////////////////
`include "SV_RAND_CHECK.sv"
program automatic test(output logic reset, arb_if arb_bus0, arb_bus1, arb_bus2);

   import  my_package::*;

   localparam  TESTS = 100;

   Transaction p0, p1, p2;
   
   initial begin
      do_reset;
      debug_test;
      random_test;
      // $display("%t: At the end error = %d", $time, $unit::error);
      $display("%t: At the end error = %d", $time, $root.top.error);
   end   

   // Basic debug test
   task debug_test;
      print_test_name("begin", "debug_test");
      @arb_bus0.cb;
      {arb_bus2.cb.en, arb_bus1.cb.en, arb_bus0.cb.en} = 3'b111;

      // check round robin
      {arb_bus2.cb.req, arb_bus1.cb.req, arb_bus0.cb.req} = 3'b111;
      @arb_bus0.cb;
      // Priority = 0
      @arb_bus0.cb;
      // Priority = 1
      @arb_bus0.cb;
      // Priority = 2
      {arb_bus2.cb.req, arb_bus1.cb.req, arb_bus0.cb.req} = 3'b110;
      @arb_bus0.cb;
      // Priority = 0 but 0 not requsting so 1 gets bus
      @arb_bus0.cb;
      // Priority = 1 so 1 still gets bus
      @arb_bus0.cb;
      // Priority = 2 so 2 gets bus
      {arb_bus2.cb.req, arb_bus1.cb.req, arb_bus0.cb.req} = 3'b000;
      @arb_bus0.cb;
      // Priority = 0 but no reqs so no grants
      @arb_bus0.cb;
      // Deassert enables and req's
      {arb_bus2.cb.req, arb_bus1.cb.req, arb_bus0.cb.req} = 3'b000;
      {arb_bus2.cb.en, arb_bus1.cb.en, arb_bus0.cb.en} = 3'b000;
      @arb_bus0.cb;
      print_test_name("end", "debug_test");
   endtask // debug_test
   
   task random_test;
      print_test_name("begin", "random_test");
      // Spawn 3 parallel transaction on each port
      for (int i=0;i<= TESTS;i++) begin
	 fork
	    begin
	       p0 = new();
	       `SV_RAND_CHECK(p0.randomize());
	       arb_bus0.cb.en <= p0.en;
	       arb_bus0.cb.req <= p0.req;
	    end
	    begin
	       p1 = new();
	       `SV_RAND_CHECK(p1.randomize());
	       arb_bus1.cb.en <= p1.en;
	       arb_bus1.cb.req <= p1.req;
	    end
	    begin
	       p2 = new();
	       `SV_RAND_CHECK(p2.randomize());
	       arb_bus2.cb.en <= p2.en;
	       arb_bus2.cb.req <= p2.req;
	    end
	 join
	 @(posedge arb_bus0.clk);
      end
   print_test_name("end", "debug_test");
   endtask // random_test
   
   task do_reset;
      @(negedge arb_bus0.clk);
      reset = 1;
      repeat (2) @(negedge arb_bus0.clk);
      reset = 0;
   endtask // do_reset
   
endprogram
