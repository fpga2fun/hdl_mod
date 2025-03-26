////////////////////////////////////////////////////////////////////////////////
// Purpose: DUT for Chap_4_Connecting_the_Testbench_and_Design/exercise4_5
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: my_reg.sv,v $
// Revision 1.2  2011/09/22 01:35:53  tumbush.tumbush
// Replaced dat with data. Added alternate clocking block solution using default.
//
// Revision 1.1  2011/05/28 20:22:57  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/08 22:21:28  Greg
// Initial check-in
//
///////////////////////////////////////////////////////////////////////////////
`default_nettype none
  module my_reg (reg_if reg_bus);

   // Register output C
   always @(posedge reg_bus.clk) begin
	reg_bus.data_out <= #50ns reg_bus.data_in;
   end
   
endmodule
