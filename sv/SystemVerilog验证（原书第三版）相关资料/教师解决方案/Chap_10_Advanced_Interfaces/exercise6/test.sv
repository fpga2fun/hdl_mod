/////////////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_10_Advanced_Interfaces/exercise6
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/09/16 21:44:54  tumbush.tumbush
// Moved from exercise8
//
//
/////////////////////////////////////////////////////////////////
`default_nettype none
  program automatic test #(ADDRESS_WIDTH=8);
   
    import my_package::*;

   virtual risc_spm_if #(.ADDRESS_WIDTH(ADDRESS_WIDTH)) risc_bus = top.risc_bus;
   
   Environment #(.ADDRESS_WIDTH(ADDRESS_WIDTH)) env;

   initial begin
      init;
      risc_bus.rst = 0;
      #100ns;
      @(negedge risc_bus.clk);
      risc_bus.rst = 1;
      env = new(risc_bus);
      env.build;
      env.run;
      env.wrap_up;
   end // initial begin


endprogram
