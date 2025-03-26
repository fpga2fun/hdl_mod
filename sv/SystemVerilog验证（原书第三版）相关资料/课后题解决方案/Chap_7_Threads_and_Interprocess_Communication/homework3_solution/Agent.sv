////////////////////////////////////////////////////////////////////////////////////////
// Purpose: Agent for Chap_7_Threads_and_Interprocess_Communication/homework3_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: Agent.sv,v $
// Revision 1.1  2011/05/29 19:12:23  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/20 20:38:24  Greg
// Initial check-in
//
////////////////////////////////////////////////////////////////////////////////////////
class Agent;
   inst_mbox gen2agt;
   inst_mbox agt2drv;
   Instruction inst;

   function new(inst_mbox gen2agt, agt2drv);
      this.gen2agt = gen2agt;
      this.agt2drv = agt2drv;
   endfunction // new

   task run();   
      forever begin
	 //print_time_string("Before get in Agent::run");
	 gen2agt.get(inst);
	 agt2drv.put(inst);
         //print_time_string("After get in Agent::run");
	 // inst.print_instruction;
      end
      //print_time_string("Done with loop in Agent::run");
   endtask
endclass // Producer
