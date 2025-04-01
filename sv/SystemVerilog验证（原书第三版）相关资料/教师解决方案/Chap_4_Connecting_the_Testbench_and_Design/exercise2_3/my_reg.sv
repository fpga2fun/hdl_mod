////////////////////////////////////////////////////////////////////////////////
// Purpose: DUT for Chap_4_Connecting_the_Testbench_and_Design/exercise2_3
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: my_reg.sv,v $
// Revision 1.2  2011/09/29 20:50:38  tumbush.tumbush
// Changed dat_* to data_*
//
// Revision 1.1  2011/05/28 20:22:56  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/08 22:18:18  Greg
// Initial check-in
//
///////////////////////////////////////////////////////////////////////////////
`default_nettype none
  module my_reg (reg_if reg_bus);

   // Register output C
   always @(posedge reg_bus.clk) begin
	reg_bus.data_out <= #25ns reg_bus.data_in;
   end
   
endmodule
