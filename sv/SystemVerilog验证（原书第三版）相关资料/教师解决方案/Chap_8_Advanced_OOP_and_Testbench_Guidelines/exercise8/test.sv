///////////////////////////////////////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_8_Advanced_OOP_and_Testbench_Guidelines/exercise8
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/29 19:16:09  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/11 22:56:15  Greg
// Initial check-in
//
///////////////////////////////////////////////////////////////////////////////////////////
`default_nettype none
  program automatic test;

   import my_package::*;

   Environment env;
   initial begin
      env = new();
      env.build();
      begin // Create error injection callback
	 Driver_cbs_drop dcd = new();
	 Driver_cbs_delay delay_cb = new();
	 env.drv.cbs.push_back(dcd); // Put into driver's Q 
	 env.drv.cbs.push_back(delay_cb); // Put into driver's Q
      end
      env.run();
      env.wrap_up();
   end // initial begin

endprogram
