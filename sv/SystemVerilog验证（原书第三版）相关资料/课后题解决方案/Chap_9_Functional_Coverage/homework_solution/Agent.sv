////////////////////////////////////////////////////////////////////////////////////////
// Purpose: Agent for Chap_9_Functional_Coverage/homework_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: Agent.sv,v $
// Revision 1.1  2011/05/29 19:24:40  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/04/02 21:36:36  Greg
// Initial check-in
//
////////////////////////////////////////////////////////////////////////////////////////
class Agent;
   instr_mbox gen2agt;
   instr_mbox agt2drv;
   Instruction instr;

   function new(instr_mbox gen2agt, agt2drv);
      this.gen2agt = gen2agt;
      this.agt2drv = agt2drv;
   endfunction // new

   task run();   
      forever begin
	 //print_time_string("Before get in Agent::run");
	 gen2agt.get(instr);
	 agt2drv.put(instr);
         //print_time_string("After get in Agent::run");
	 // instr.print_instruction;
      end
      //print_time_string("Done with loop in Agent::run");
   endtask
endclass // Producer
