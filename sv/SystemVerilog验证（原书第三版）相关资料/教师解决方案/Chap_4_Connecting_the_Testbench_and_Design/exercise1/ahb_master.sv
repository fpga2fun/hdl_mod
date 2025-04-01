////////////////////////////////////////////////////////////////////////////////
// Purpose: AHB master for Chap_4_Connecting_the_Testbench_and_Design/exercise1
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: ahb_master.sv,v $
// Revision 1.1  2011/05/28 20:22:55  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/08 22:13:59  Greg
// Initial check-in
//
////////////////////////////////////////////////////////////////////////////////
`default_nettype none
  module ahb_master(ahb_if ahb_bus);

   localparam 	IDLE = 2'b00,
                NONSEQ = 2'b10;

   always #50ns ahb_bus.HCLK = ~ahb_bus.HCLK;

   initial begin
      @(posedge ahb_bus.HCLK);
      ahb_bus.HTRANS = NONSEQ;
      @(posedge ahb_bus.HCLK);
      ahb_bus.HTRANS = 2'b01;
      @(posedge ahb_bus.HCLK);
      $finish;
   end
   
endmodule
