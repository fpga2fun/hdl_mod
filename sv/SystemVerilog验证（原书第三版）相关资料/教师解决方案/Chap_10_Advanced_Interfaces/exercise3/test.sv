/////////////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_10_Advanced_Interfaces/exercise3
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/09/16 21:24:10  tumbush.tumbush
// Moved from exercise3_4
//
//
/////////////////////////////////////////////////////////////////
`default_nettype none
  program automatic test();
   
    import my_package::*;

   virtual risc_spm_if risc_bus = top.risc_bus;
   
   Environment env;

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
