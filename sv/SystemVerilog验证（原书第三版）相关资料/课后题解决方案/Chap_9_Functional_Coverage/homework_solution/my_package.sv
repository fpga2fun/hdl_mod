////////////////////////////////////////////////////////////////////////////////////////
// Purpose: Package for Chap_9_Functional_Coverage/homework_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: my_package.sv,v $
// Revision 1.1  2011/05/29 19:24:40  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/04/02 21:36:36  Greg
// Initial check-in
//
////////////////////////////////////////////////////////////////////////////////////////
`default_nettype none
  package my_package;

   

   // Enumerate all the opcodes
   typedef enum  bit [3:0] {NOP, ADD, SUB, AND, NOT, RD, WR, BR, BRZ, RDI, HALT=4'b1111} opcode_t;
   typedef enum  {NONE, SRC, DEST, BOTH} args_t; // What operands are used, src, dest, or both?
   typedef enum  {SHORT, LONG} instr_length_t;  // Is this a long (2-byte) instruction or a short (1-byte) instruction
   args_t args_assoc[opcode_t];
   instr_length_t instr_length_assoc[opcode_t];

   localparam num_tests = 1000;

   typedef bit [7:0] u_byte_t; // Unsigned byte

   function void init;
      // What operands are used, src, dest, or both?
      args_assoc[NOP] = NONE;
      args_assoc[ADD] = BOTH;
      args_assoc[SUB] = BOTH; 
      args_assoc[AND] = BOTH;
      args_assoc[NOT] = BOTH;
      args_assoc[RD] = DEST;
      args_assoc[WR] = SRC; 
      args_assoc[BR] = NONE; 
      args_assoc[BRZ] = NONE;
       args_assoc[RDI] = DEST;
      args_assoc[HALT] = NONE;

      // Is this a long (2-byte) instruction or a short (1-byte) instruction
      instr_length_assoc[NOP]  = SHORT;
      instr_length_assoc[ADD]  = SHORT;
      instr_length_assoc[SUB]  = SHORT; 
      instr_length_assoc[AND]  = SHORT;
      instr_length_assoc[NOT]  = SHORT;
      instr_length_assoc[RD]   = LONG;
      instr_length_assoc[WR]   = LONG; 
      instr_length_assoc[BR]   = LONG; 
      instr_length_assoc[BRZ]  = LONG;
      instr_length_assoc[RDI]  = LONG;
      instr_length_assoc[HALT] = SHORT;

   endfunction // init

   function void print_time_string(input string my_string);
      $display("%0t: %0s", $time, my_string);
   endfunction // print_time_string
               
class Instruction;

   rand opcode_t opcode;
   rand bit [1:0] src, dest; // source and destination of the opcode
   rand bit [7:0] memory_location; // For 2-byte, i.e. LONG  instructions only. Memory location
   rand bit [7:0] read_data; // Data returned by the 3rd memory access of a read
   static bit [7:0] count = 0; // Count to keep track of the memory address
   bit [7:0] 	    address; // Starting memory address for the Instruction
   static string    opcode_str; // To be able to view the instruction in the viewer.

   constraint no_BR {(opcode != BR);}
   constraint no_BRZ {(opcode != BRZ);}
   constraint no_HALT {(opcode != HALT);}

   function void print_instruction;
      
      // Print out the instructions with no arguments
      if (args_assoc[opcode] == NONE)
        $display("%0t: Instruction is %s at address", $time, opcode, address);
      else if (args_assoc[opcode] == SRC)
        $display("%0t: Instruction is %s 0x%0h at address", $time, opcode, src, address);
      else if (args_assoc[opcode] == DEST)
        $display("%0t: Instruction is %s 0x%0h at address", $time, opcode, dest, address);
      else if (args_assoc[opcode] == BOTH)
        $display("%0t: Instruction is %s 0x%0h 0x%0h at address", $time, opcode, src, dest, address);
      else
        $display("%0dt: Instruction of %s and args_assoc[opcode] of %s not found", $time, opcode, args_assoc[opcode]);
       
   endfunction // print_instruction

   function new();
      address = count++;
   endfunction // new

   // If the instruction is a 2-byte instruction increment address and count
   function void post_randomize;
      $display("%t: Calling post_randomize with opcode = %s", $time, opcode);
      if  (instr_length_assoc[opcode] == LONG) begin
	 count = count+1;
	 // address = address++;
	 print_time_string("Incremented address and count in post randomize");
      end
      opcode_str = opcode.name;
   endfunction
   
endclass

   // Typedef a mailbox of type Instruction
   typedef mailbox #(Instruction) instr_mbox;

   // Handle to an instruction and old instruction
   Instruction instr;
   Instruction old_instr;

   covergroup CovOpcode;
      option.auto_bin_max = 256; // Don't restrict number of auto bins
      type_option.merge_instances = 1; // to show bins
      //All opcodes have been executed, except BR, BRZ, and HALT.
      all_opcodes_executed: coverpoint instr.opcode{
         bins opcodes[] = {NOP, ADD, SUB, AND, NOT, RD, WR, RDI};}


      // The source for every opcode must have been R0, R1, R2, and R3
      // First create a covergroup with opcodes that have a src field
      opcodes_with_src: coverpoint instr.opcode{
         bins opcodes[] = {ADD, SUB, AND, NOT, WR};}
      src: coverpoint instr.src;
      all_opcodes_executed_x_src: cross opcodes_with_src, src;

      
      // The destination for every opcode must have been R0, R1, R2, and R3
      // first create a coverpoint with opcodes that have a dest field
      opcodes_with_dest: coverpoint instr.opcode{
         bins opcodes[] = {ADD, SUB, AND, NOT, RD, RDI};}
      dest: coverpoint instr.dest;
      all_opcodes_executed_x_dest: cross  opcodes_with_dest, dest;

      // Every instruction has been preceded and followed by every other instruction.
      all_opcodes_executed_old: coverpoint old_instr.opcode{
         bins old_opcodes[] = {NOP, ADD, SUB, AND, NOT, RD, WR, RDI};}
      all_permutations_opcodes: cross  all_opcodes_executed_old, all_opcodes_executed;

      // For opcodes that have both a source and destination, all permutations 
      // of source and destination have been executed.
      // First create a coverpoint with opcodes that have both a src and destination field
      opcodes_with_src_dest: coverpoint instr.opcode{
	 bins opcodes[] = {ADD, SUB, AND, NOT};}
      all_opcodes_executed_x_dest_x_src: cross opcodes_with_src_dest, src, dest;

      // All memory locations have been written.
      // First create a coverpoint with opcodes WR only
      // Then a coverpoint of memory_location
      opcodes_wr: coverpoint instr.opcode{
	 bins opcodes[] = {WR};}
      memory_loc: coverpoint instr.memory_location;
      all_mem_written: cross opcodes_wr, memory_loc;

      // All memory locations have been read by a RD instruction.
      opcodes_rd: coverpoint instr.opcode{
	 bins opcodes[] = {RD};}
      all_mem_read: cross opcodes_rd, memory_loc;
      
   endgroup // CovOpcode
   
  // Abstract driver callback class.
  virtual 	 class Driver_cbs;
      pure virtual task post_tx(Instruction cb_instr);
   endclass // Driver_cbs

   // Callback to collect coverage
class Driver_cbs_cover extends Driver_cbs;

    // Handle to covergroup
   CovOpcode cov;
   
   function new();
      this.cov = new();
      old_instr = new();
   endfunction // new
   
   
   virtual task post_tx(Instruction cb_instr);

      // Copy instruction passed to task to instr for collecting coverage.
      instr = cb_instr;
      
      cov.sample();
      old_instr = instr; // copy to old instruction
      	 if ((cov.all_opcodes_executed.get_coverage() == 100) && 
            (cov.all_opcodes_executed_x_src.get_coverage() == 100) &&
            (cov.all_opcodes_executed_x_dest.get_coverage() == 100) &&
            (cov.all_permutations_opcodes.get_coverage() == 100) &&
            (cov.opcodes_with_src_dest.get_coverage() == 100) &&
            (cov.all_mem_written.get_coverage() == 100) &&
            (cov.all_mem_read.get_coverage() == 100)) begin
	    print_time_string("All coverage requirements complete");
	    $finish;
	 end

   endtask // pre_tx
   
endclass // Driver_cbs



endpackage
