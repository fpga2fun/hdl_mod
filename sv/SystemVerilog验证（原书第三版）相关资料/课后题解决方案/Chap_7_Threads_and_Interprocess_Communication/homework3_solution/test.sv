////////////////////////////////////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_7_Threads_and_Interprocess_Communication/homework3_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/29 19:12:23  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/20 20:38:24  Greg
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

   initial begin
      init;
      risc_bus.rst = 0;
      #100ns;
      @(negedge risc_bus.clk);
      risc_bus.rst = 1;
      env = new();
      env.build;
      env.run;
   end // initial begin

   initial begin
      #5000ns;
      $finish;
   end
   

endprogram
