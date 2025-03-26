////////////////////////////////////////////////////////////////////////////////////////////
// Purpose: Environment for Chap_9_Functional_Coverage/homework_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: Environment.sv,v $
// Revision 1.1  2011/05/29 19:24:40  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/04/02 21:36:36  Greg
// Initial check-in
//
////////////////////////////////////////////////////////////////////////////////////////////
class Environment;
   Generator gen;
   Agent agt;
   Driver drv;
   instr_mbox gen2agt;
   instr_mbox agt2drv;

   function void build;
      // Initialize mailbox to size 1
      //print_time_string("Before gen2drv = new(1)");
      gen2agt = new(1);
      agt2drv = new(1);
      //print_time_string("After gen2drv = new(1)");

      // Initialize transactors and pass the mailbox
      gen = new(gen2agt);
      agt = new(gen2agt, agt2drv);
      drv = new(agt2drv);
   endfunction // build

   task run();
      fork
	 gen.run();
	 agt.run();
	 drv.run();
      join
   endtask // run

endclass // Environment
