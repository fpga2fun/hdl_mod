//////////////////////////////////////////////////////////////////////////
// Purpose: Top level testbench for Chap_9_Functional_Coverage/exercise3_4
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: top.sv,v $
// Revision 1.1  2011/05/29 19:24:36  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/12 15:35:04  Greg
// Initial check-in
//
////////////////////////////////////////////////////////////////////////
`default_nettype none
`include "busifc.sv"
module top;
   bit clk;
   
   busifc bus(clk);
   
test test(bus);

   initial begin
      forever begin
	 #50ns;
	 clk = !clk;
      end
   end
   
endmodule

