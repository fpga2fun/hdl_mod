////////////////////////////////////////////////////////////////////////////////
// Purpose: Testbench for Chap_7_Threads_and_Interprocess_Communication/homework1_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: top.sv,v $
// Revision 1.1  2011/05/29 19:13:48  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/18 20:10:32  Greg
// Initial checkin
//
////////////////////////////////////////////////////////////////////////////////
`default_nettype none
`include "arb_if.sv"
module top;

   bit clk, reset;
   bit [2:0] golden_grant;
   int 	     error = 0;
   
   // arb interface for port 0, 1, and 2
   arb_if arb_bus0(clk);
   arb_if arb_bus1(clk);
   arb_if arb_bus2(clk);

   // The test
   test test(.reset(reset), .arb_bus0(arb_bus0.master), .arb_bus1(arb_bus1.master), .arb_bus2(arb_bus2.master));

   // The arbiter DUT
  arbiter arbiter(
		 .clk(clk),
		 .reset(reset),
		 .req0(arb_bus0.req),
		 .en0(arb_bus0.en),
		 .grant0(arb_bus0.grant),
                 .req1(arb_bus1.req),   
		 .en1(arb_bus1.en),
		 .grant1(arb_bus1.grant),
		 .req2(arb_bus2.req),  
		 .en2(arb_bus2.en),
		 .grant2(arb_bus2.grant)
		 );

// Instantiate the golden model
   golden golden(
		 .clk(clk),
		 .reset(reset),
		 .req({arb_bus2.req, arb_bus1.req, arb_bus0.req}),
		 .en({arb_bus2.en, arb_bus1.en, arb_bus0.en}),
		 .grant(golden_grant)
		 );
   
   // Create a clock
   initial begin
      clk = 1'b0;
      forever #50ns clk=!clk;
   end

// At the negative edge of every clock check that the golden models grant
// output matches the DUT's grant output
   always @(negedge clk) begin
      if (golden_grant[2] !== arb_bus2.grant) begin
	$display("%t: Error golden_grant=%0b and DUT grant=%0b", $time, golden_grant[2], arb_bus2.grant);
         error++;
      end
      if (golden_grant[1] !== arb_bus1.grant) begin
	$display("%t: Error golden_grant=%0b and DUT grant=%0b", $time, golden_grant[1], arb_bus1.grant);
         error++;
      end
      if (golden_grant[0] !== arb_bus0.grant) begin
	$display("%t: Error golden_grant=%0b and DUT grant=%0b", $time, golden_grant[0], arb_bus0.grant);
         error++;
      end
   end

   
endmodule // test

