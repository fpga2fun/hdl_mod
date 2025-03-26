////////////////////////////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap10_Advanced_Interfaces/exercise4
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/09/16 21:37:18  tumbush.tumbush
// Moved from exercise5_6
//
//
////////////////////////////////////////////////////////////////////////////////
`default_nettype none
  program automatic test #(NUM_RISC_BUS = 3);
   
    import my_package::*;

   virtual risc_spm_if risc_bus_array[NUM_RISC_BUS];
   
   Environment env[];

   initial begin
      risc_bus_array = top.risc_bus_array;
      init;
      env = new[NUM_RISC_BUS];
      foreach (env[i])
	env[i] = new(risc_bus_array[i], i);

      foreach (env[i]) begin
	 automatic int j = i; // Necessary to declare as automatic in questa
	 fork begin           // even though the program is automatic?
	    env[j].build;
	    env[j].run;
	    env[j].wrap_up;
	 end
	 join_none
	 #10us;
      end
      
   end // initial begin


endprogram
