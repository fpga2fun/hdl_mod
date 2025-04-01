/////////////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_10_Advanced_Interfaces/exercise1_2
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.2  2011/09/17 20:40:33  tumbush.tumbush
// Don't use typedef for mailbox
//
// Revision 1.1  2011/05/27 02:45:19  tumbush.tumbush
// Checked into cloud
//
// Revision 1.1  2011/05/15 19:56:22  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////////
`default_nettype none
  program automatic test(risc_spm_if risc_bus);
   
    import my_package::*;

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
      $finish;
   end // initial begin


endprogram
