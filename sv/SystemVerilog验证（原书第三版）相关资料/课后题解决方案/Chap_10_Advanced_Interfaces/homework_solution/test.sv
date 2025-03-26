////////////////////////////////////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_10_Advanced_Interfaces/homework_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.2  2011/09/17 20:56:38  tumbush.tumbush
// Declare mailbox size/type instead of using a typedef. Declare mailbox argument to new as input
//
// Revision 1.1  2011/05/27 02:58:59  tumbush.tumbush
// Checked into cloud.
//
// Revision 1.1  2011/04/05 22:24:10  Greg
// Initial check-in
//
////////////////////////////////////////////////////////////////////////////////////////
`default_nettype none
  program automatic test #(ADDRESS_WIDTH=8);
   
   virtual risc_spm_if #(.ADDRESS_WIDTH(ADDRESS_WIDTH)) risc_bus = top.risc_bus; // Use an XMR
   
   import my_package::*;

   Environment #(.ADDRESS_WIDTH(ADDRESS_WIDTH)) env;
   Driver_cbs_cover #(.ADDRESS_WIDTH(ADDRESS_WIDTH)) cb_cover;

   initial begin
      init;
      risc_bus.rst = 0;
      #100ns;
      @(negedge risc_bus.clk);
      risc_bus.rst = 1;
      env = new(risc_bus);
      env.build;
      cb_cover = new();
      env.drv.cbs.push_back(cb_cover); 
      env.run;
   end // initial begin
   
endprogram
