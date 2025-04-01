////////////////////////////////////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_9_Functional_Coverage/homework_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/29 19:24:40  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/04/02 21:36:36  Greg
// Initial check-in
//
////////////////////////////////////////////////////////////////////////////////////////
`default_nettype none
  program automatic test(risc_spm_if risc_bus);
   
    import my_package::*;
     // `include "Instruction.sv"
    `include "Generator.sv"
    `include "Agent.sv"
    `include "Driver.sv"
    `include "Environment.sv"

   Environment env;
   Driver_cbs_cover cb_cover;

   initial begin
      init;
      risc_bus.rst = 0;
      #100ns;
      @(negedge risc_bus.clk);
      risc_bus.rst = 1;
      env = new();
      env.build;
      cb_cover = new();
      env.drv.cbs.push_back(cb_cover); 
      env.run;
   end // initial begin
   
endprogram
