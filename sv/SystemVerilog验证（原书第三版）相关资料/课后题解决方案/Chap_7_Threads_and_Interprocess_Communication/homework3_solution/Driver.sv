////////////////////////////////////////////////////////////////////////////////////////
// Purpose: Driver for Chap_7_Threads_and_Interprocess_Communication/homework3_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: Driver.sv,v $
// Revision 1.1  2011/05/29 19:12:23  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/20 20:38:24  Greg
// Initial check-in
//
////////////////////////////////////////////////////////////////////////////////////////
class Driver;
   inst_mbox agt2drv;
   Instruction inst;
   static string    instr_str; // To be able to view the instruction in the viewer.
   
   function new(inst_mbox agt2drv);
      this.agt2drv = agt2drv;
   endfunction // new

   task run();
      repeat (num_tests) begin
	 //print_time_string("Before get in Driver::run");
	 agt2drv.peek(inst); // Look at the message in the mailbox but don't remove it until the transaction is complete.
	 //print_time_string("After get in Driver::run");

         // compile the instruction
	 instr_str = create_instr_str(inst);
         if (instr_length_assoc[inst.opcode] == LONG)
           do_long(inst);
         else
           do_short(inst);	   

	 $display("%t Waiting for event on risc_bus.address for opcode = %s", $time, inst.opcode);
	 @(risc_bus.address); // Wait for next fetch
	 $display("%t Got an event on risc_bus.address for opcode = %s", $time, inst.opcode);

	 // inst.print_instruction;
	 agt2drv.get(inst); // Transaction is complete remove the message.
      end
   endtask // run

   task do_long(input Instruction inst);
      bit [15:0] 	   compiled_long;  // Hold compiled long instructions
      compiled_long = compile_long(inst);
      if (risc_bus.address === inst.address) // Check for valid address
	risc_bus.data_out = compiled_long[15:8];
      else
	$display("%t: Error: Instruction for address %h has not been generated yet", $time, risc_bus.address);
      
      // Wait for request of 2nd byte of data
      @(risc_bus.address);
      if (risc_bus.address === (u_byte_t '(inst.address+1))) // Check for valid address. Cast to unsigned byte for rollover.
	risc_bus.data_out = compiled_long[7:0];
      else
	$display("%t: Error: Instruction for address %h has not been generated for memory fetch yet", $time, risc_bus.address);

      // If instruction is RD wait for final read
      if (inst.opcode == RD) begin
	@(risc_bus.address);
	 risc_bus.data_out = inst.read_data;
      end

      // If instruction is a WR wait for final write
      if (inst.opcode == WR) begin
	@(risc_bus.address);
      end
      
   endtask // do_long

   task do_short(input Instruction inst);
            bit [7:0] 	   compiled_short; // Hold compiled short instructions
      	    compiled_short = compile_short(inst);
	    if (risc_bus.address === inst.address) // Check for valid address
	      risc_bus.data_out = compiled_short;
            else
	      $display("%t: Error: Instruction for address %h has not been generated yet", $time, risc_bus.address);
   endtask // do_long
 

    // Compile the 1-byte instructions here
   function bit [7:0] compile_short (input Instruction inst);
      if (args_assoc[inst.opcode] == NONE) // Only NOP and HALT
        compile_short = {inst.opcode, 4'b0};
      else if (args_assoc[inst.opcode] == BOTH) // ADD, SUB, AND, NOT
	compile_short = {inst.opcode, inst.src, inst.dest};
      else
        $display("%0dt: Instruction of %s is not found", $time, inst.opcode);
   endfunction
      
       // Compile the 2-byte instruction here
   function bit [15:0] compile_long(input Instruction inst);
      if (args_assoc[inst.opcode] == SRC) // WR
        compile_long = {inst.opcode, inst.src, 2'b0, inst.memory_location};
      else if (args_assoc[inst.opcode] == DEST) // RD and RDI
        compile_long = {inst.opcode, 2'b0, inst.dest, inst.memory_location};
      else if (args_assoc[inst.opcode] == NONE) // BR, BRZ
	compile_long = {inst.opcode, 2'b0, 2'b0, inst.memory_location};
      else
        $display("%0dt: Instruction of %s is not found", $time, inst.opcode);
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
  function string create_instr_str(input Instruction inst);
     case(inst.opcode.name)
       "NOP": create_instr_str = "NOP";
       "ADD": create_instr_str = {"ADD", decode_reg(inst.src),  decode_reg(inst.dest)};     
       "SUB": create_instr_str = {"SUB", decode_reg(inst.src),  decode_reg(inst.dest)};     
       "AND": create_instr_str = {"AND", decode_reg(inst.src),  decode_reg(inst.dest)};     
       "NOT": create_instr_str = {"NOT", decode_reg(inst.src),  decode_reg(inst.dest)};     
       "RD": create_instr_str = {"RD", decode_reg(inst.dest),  " 0x", decode_mem(inst.memory_location)};      
       "WR": create_instr_str = {"WR", decode_reg(inst.src),  " 0x", decode_mem(inst.memory_location)};      
       "BR": create_instr_str = "BR";      
       "BRZ": create_instr_str = "BRZ";     
       "RDI": create_instr_str = {"RDI", decode_reg(inst.dest),  " 0x", decode_mem(inst.memory_location)};     
       "HALT": create_instr_str = "HALT";
     endcase // case (inst.opcode.name)    
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
