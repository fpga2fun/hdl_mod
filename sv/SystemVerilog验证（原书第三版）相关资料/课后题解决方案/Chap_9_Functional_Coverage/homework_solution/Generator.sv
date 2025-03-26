////////////////////////////////////////////////////////////////////////////////////////
// Purpose: Generator for Chap_9_Functional_Coverage/homework_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: Generator.sv,v $
// Revision 1.2  2011/09/15 19:20:50  tumbush.tumbush
// Replaced assert with SV_RAND_CHECK
//
// Revision 1.1  2011/05/29 19:24:40  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/04/02 21:36:36  Greg
// Initial check-in
//
////////////////////////////////////////////////////////////////////////////////////////
// from project_rdi_virtual_if
`include "SV_RAND_CHECK.sv"

class Generator;
   instr_mbox gen2agt;
   Instruction instr;
   Instruction old_instr;

   bit 	   coverage_done = 0;
   
   function new(instr_mbox gen2agt);
      // CovOpcode = new();
      this.gen2agt = gen2agt;
   endfunction // new

   task run();
      	 old_instr = new();
	 instr = new();

       forever begin
         
	 old_instr = instr;
	 instr = new();
	 `SV_RAND_CHECK(instr.randomize());
	 instr.print_instruction;
 	  
	 gen2agt.put(instr);
      end
      print_time_string("Generator is done");
   endtask
endclass

