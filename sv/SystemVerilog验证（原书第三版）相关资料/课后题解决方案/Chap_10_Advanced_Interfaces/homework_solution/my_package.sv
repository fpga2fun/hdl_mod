//////////////////////////////////////////////////////////////////////
// Purpose: Package for Chap_10_Advanced_Interfaces/homework_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: my_package.sv,v $
// Revision 1.2  2011/09/17 20:56:38  tumbush.tumbush
// Declare mailbox size/type instead of using a typedef. Declare mailbox argument to new as input
//
// Revision 1.1  2011/05/27 02:58:59  tumbush.tumbush
// Checked into cloud.
//
// Revision 1.1  2011/04/05 22:24:10  Greg
// Initial check-in
//
//////////////////////////////////////////////////////////////////////
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
               
class Instruction  #(ADDRESS_WIDTH=8);

   rand opcode_t opcode;
   rand bit [1:0] src, dest; // source and destination of the opcode
   rand bit [ADDRESS_WIDTH-1:0] memory_location; // For 2-byte, i.e. LONG  instructions only. Memory location
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

/*
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
 */ 
  
  // Abstract driver callback class.
  virtual 	 class Driver_cbs #(ADDRESS_WIDTH=8);
      pure virtual task post_tx(Instruction #(.ADDRESS_WIDTH(ADDRESS_WIDTH)) cb_instr);
   endclass // Driver_cbs

   // Callback to collect coverage
class Driver_cbs_cover #(ADDRESS_WIDTH=8) extends Driver_cbs #(.ADDRESS_WIDTH(ADDRESS_WIDTH));

      // Handle to an instruction and old instruction
   Instruction #(.ADDRESS_WIDTH(ADDRESS_WIDTH)) instr;
   Instruction #(.ADDRESS_WIDTH(ADDRESS_WIDTH)) old_instr;

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


    // Handle to covergroup
   // CovOpcode cov;
   
   function new();
      // this.cov = new();
      CovOpcode = new();
      old_instr = new();
   endfunction // new
   
   
   virtual task post_tx(Instruction #(.ADDRESS_WIDTH(ADDRESS_WIDTH)) cb_instr);

      // Copy instruction passed to task to instr for collecting coverage.
      instr = cb_instr;
      
      // cov.sample();
      CovOpcode.sample();
      old_instr = instr; // copy to old instruction
      	 if ((CovOpcode.all_opcodes_executed.get_coverage() == 100) && 
            (CovOpcode.all_opcodes_executed_x_src.get_coverage() == 100) &&
            (CovOpcode.all_opcodes_executed_x_dest.get_coverage() == 100) &&
            (CovOpcode.all_permutations_opcodes.get_coverage() == 100) &&
            (CovOpcode.opcodes_with_src_dest.get_coverage() == 100) &&
            (CovOpcode.all_mem_written.get_coverage() == 100) &&
            (CovOpcode.all_mem_read.get_coverage() == 100)) begin
	    print_time_string("All coverage requirements complete");
	    $finish;
	 end

   endtask // pre_tx
   
endclass // Driver_cbs

class Generator #(ADDRESS_WIDTH=8);
   mailbox #(Instruction #(.ADDRESS_WIDTH(ADDRESS_WIDTH))) gen2agt;
   Instruction #(.ADDRESS_WIDTH(ADDRESS_WIDTH)) instr;
   Instruction #(.ADDRESS_WIDTH(ADDRESS_WIDTH)) old_instr;

   bit 	   coverage_done = 0;
   
   function new(input mailbox #(Instruction #(.ADDRESS_WIDTH(ADDRESS_WIDTH))) gen2agt);
      this.gen2agt = gen2agt;
   endfunction // new

   task run();
      	 old_instr = new();
	 instr = new();

       forever begin
         
	 old_instr = instr;
	 instr = new();
	 assert(instr.randomize());
	 instr.print_instruction;
 	  
	 gen2agt.put(instr);
      end
      print_time_string("Generator is done");
   endtask
endclass

class Agent#(ADDRESS_WIDTH=8);
   mailbox #(Instruction #(.ADDRESS_WIDTH(ADDRESS_WIDTH))) gen2agt;
   mailbox #(Instruction #(.ADDRESS_WIDTH(ADDRESS_WIDTH))) agt2drv;
   Instruction #(.ADDRESS_WIDTH(ADDRESS_WIDTH)) instr;

   function new(input mailbox #(Instruction #(.ADDRESS_WIDTH(ADDRESS_WIDTH))) gen2agt, agt2drv);
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

class Driver #(ADDRESS_WIDTH=8);
   mailbox #(Instruction #(.ADDRESS_WIDTH(ADDRESS_WIDTH))) agt2drv;
   Instruction #(.ADDRESS_WIDTH(ADDRESS_WIDTH)) instr;
   static string    instr_str; // To be able to view the instruction in the viewer.
   Driver_cbs #(.ADDRESS_WIDTH(ADDRESS_WIDTH)) cbs[$];

   virtual 	    risc_spm_if #(.ADDRESS_WIDTH(ADDRESS_WIDTH)) risc_bus;
   
   function new(input mailbox #(Instruction #(.ADDRESS_WIDTH(ADDRESS_WIDTH))) agt2drv, input virtual risc_spm_if #(.ADDRESS_WIDTH(ADDRESS_WIDTH)) risc_bus);
      this.agt2drv = agt2drv;
      this.risc_bus = risc_bus;
   endfunction // new

   task run();
      forever begin
	 //print_time_string("Before get in Driver::run");
	 agt2drv.peek(instr); // Look at the message in the mailbox but don't remove it until the transaction is complete.
	 //print_time_string("After get in Driver::run");

         // compile the instruction
	 instr_str = create_instr_str(instr);
         if (instr_length_assoc[instr.opcode] == LONG)
           do_long(instr);
         else
           do_short(instr);	   

	 // Wait for instruction to end
	 case (instr.opcode)
	   NOT, NOP: repeat (3) @(posedge risc_bus.clk);
	   AND, ADD, SUB: repeat (4) @(posedge risc_bus.clk);
	   RDI, RD, WR: repeat (2) @(posedge risc_bus.clk);
	 endcase // case (instr.opcode)

	 // inst.print_instruction;
	 agt2drv.get(instr); // Transaction is complete remove the message.
	 foreach (cbs[i]) 
           cbs[i].post_tx(instr);
      end
   endtask // run

   task do_long(input Instruction #(.ADDRESS_WIDTH(ADDRESS_WIDTH)) instr);
      bit [15:0] 	   compiled_long;  // Hold compiled long instructions
      compiled_long = compile_long(instr);
	risc_bus.data_out = compiled_long[15:8];

      // Wait for request of 2nd byte of data
      repeat (2) @(posedge risc_bus.clk);
	risc_bus.data_out = compiled_long[7:0];

      // If instruction is RD wait for final read
      if (instr.opcode == RD) begin
	@(posedge risc_bus.clk);
	 risc_bus.data_out = instr.read_data;
      end

      // If instruction is a WR wait for final write
      if (instr.opcode == WR) begin
	@(posedge risc_bus.clk);
      end
      
   endtask // do_long

   task do_short(input Instruction #(.ADDRESS_WIDTH(ADDRESS_WIDTH)) instr);
            bit [7:0] 	   compiled_short; // Hold compiled short instructions
      	    compiled_short = compile_short(instr);
	    risc_bus.data_out = compiled_short;
   endtask
 

    // Compile the 1-byte instructions here
   function bit [7:0] compile_short (input Instruction #(.ADDRESS_WIDTH(ADDRESS_WIDTH)) instr);
      if (args_assoc[instr.opcode] == NONE) // Only NOP and HALT
        compile_short = {instr.opcode, 4'b0};
      else if (args_assoc[instr.opcode] == BOTH) // ADD, SUB, AND, NOT
	compile_short = {instr.opcode, instr.src, instr.dest};
      else
        $display("%0dt: Instruction of %s is not found", $time, instr.opcode);
   endfunction
      
       // Compile the 2-byte instruction here
   function bit [15:0] compile_long(input Instruction #(.ADDRESS_WIDTH(ADDRESS_WIDTH)) instr);
      if (args_assoc[instr.opcode] == SRC) // WR
        compile_long = {instr.opcode, instr.src, 2'b0, instr.memory_location};
      else if (args_assoc[instr.opcode] == DEST) // RD and RDI
        compile_long = {instr.opcode, 2'b0, instr.dest, instr.memory_location};
      else if (args_assoc[instr.opcode] == NONE) // BR, BRZ
	compile_long = {instr.opcode, 2'b0, 2'b0, instr.memory_location};
      else
        $display("%0dt: Instruction of %s is not found", $time, instr.opcode);
   endfunction // compile_long

   function string decode_reg(input [1:0] reg_value);
      case (reg_value)
	2'b00: decode_reg = " R0";
	2'b01: decode_reg = " R1";
	2'b10: decode_reg = " R2";
	2'b11: decode_reg = " R3";
      endcase // case (reg_value)
   endfunction // decode_reg

   function string decode_mem(input [7:0] memory_location);
      decode_mem = {hex2ascii(memory_location[7:4]), hex2ascii(memory_location[3:0])};
   endfunction // decode_mem
   
   // Parse the instruction into a recognizable string to view
  function string create_instr_str(input Instruction #(.ADDRESS_WIDTH(ADDRESS_WIDTH)) instr);
     case(instr.opcode.name)
       "NOP": create_instr_str = "NOP";
       "ADD": create_instr_str = {"ADD", decode_reg(instr.src),  decode_reg(instr.dest)};     
       "SUB": create_instr_str = {"SUB", decode_reg(instr.src),  decode_reg(instr.dest)};     
       "AND": create_instr_str = {"AND", decode_reg(instr.src),  decode_reg(instr.dest)};     
       "NOT": create_instr_str = {"NOT", decode_reg(instr.src),  decode_reg(instr.dest)};     
       "RD": create_instr_str = {"RD", decode_reg(instr.dest),  " 0x", decode_mem(instr.memory_location)};      
       "WR": create_instr_str = {"WR", decode_reg(instr.src),  " 0x", decode_mem(instr.memory_location)};      
       "BR": create_instr_str = "BR";      
       "BRZ": create_instr_str = "BRZ";     
       "RDI": create_instr_str = {"RDI", decode_reg(instr.dest),  " 0x", decode_mem(instr.memory_location)};     
       "HALT": create_instr_str = "HALT";
     endcase // case (instr.opcode.name)    
  endfunction

   function string hex2ascii(input [3:0] hex_val);
      case(hex_val)
	4'h0: hex2ascii = "0";
	4'h1: hex2ascii = "1";
	4'h2: hex2ascii = "2";
	4'h3: hex2ascii = "3";
	4'h4: hex2ascii = "4";
	4'h5: hex2ascii = "5";
	4'h6: hex2ascii = "6";
	4'h7: hex2ascii = "7";
	4'h8: hex2ascii = "8";
	4'h9: hex2ascii = "9";
	4'hA: hex2ascii = "A";
	4'hB: hex2ascii = "B";
	4'hC: hex2ascii = "C";
	4'hD: hex2ascii = "D";
	4'hE: hex2ascii = "E";
	4'hF: hex2ascii = "F";
      endcase // case (hex_val)
      
   endfunction // hex2ascii
   
   
endclass // Driver

class Environment #(ADDRESS_WIDTH=8);
   Generator #(.ADDRESS_WIDTH(ADDRESS_WIDTH)) gen;
   Agent #(.ADDRESS_WIDTH(ADDRESS_WIDTH)) agt;
   Driver #(.ADDRESS_WIDTH(ADDRESS_WIDTH)) drv;

   mailbox #(Instruction #(.ADDRESS_WIDTH(ADDRESS_WIDTH))) gen2agt;
   mailbox #(Instruction #(.ADDRESS_WIDTH(ADDRESS_WIDTH))) agt2drv;

   virtual 	    risc_spm_if #(.ADDRESS_WIDTH(ADDRESS_WIDTH)) risc_bus;

   function new(input virtual risc_spm_if #(.ADDRESS_WIDTH(ADDRESS_WIDTH)) risc_bus);
     this.risc_bus = risc_bus;
   endfunction // new

   function void build;
      // Initialize mailbox to size 1
      //print_time_string("Before gen2drv = new(1)");
      gen2agt = new(1);
      agt2drv = new(1);
      //print_time_string("After gen2drv = new(1)");

      // Initialize transactors and pass the mailbox and virtual interface
      gen = new(gen2agt);
      agt = new(gen2agt, agt2drv);
      drv = new(agt2drv, risc_bus);
   endfunction // build

   task run();
      fork
	 gen.run();
	 agt.run();
	 drv.run();
      join
   endtask // run

endclass // Environment

endpackage
