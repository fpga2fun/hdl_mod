////////////////////////////////////////////////////////////////////////////////////////
// Purpose: Driver for Chap_9_Functional_Coverage/homework_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: Driver.sv,v $
// Revision 1.1  2011/05/29 19:24:40  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/04/02 21:36:36  Greg
// Initial check-in
//
////////////////////////////////////////////////////////////////////////////////////////
class Driver;
   instr_mbox agt2drv;
   Instruction instr;
   static string    instr_str; // To be able to view the instruction in the viewer.
   Driver_cbs cbs[$];
   
   function new(instr_mbox agt2drv);
      this.agt2drv = agt2drv;
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

   task do_long(input Instruction instr);
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

   task do_short(input Instruction instr);
            bit [7:0] 	   compiled_short; // Hold compiled short instructions
      	    compiled_short = compile_short(instr);
	    risc_bus.data_out = compiled_short;
   endtask
 

    // Compile the 1-byte instructions here
   function bit [7:0] compile_short (input Instruction instr);
      if (args_assoc[instr.opcode] == NONE) // Only NOP and HALT
        compile_short = {instr.opcode, 4'b0};
      else if (args_assoc[instr.opcode] == BOTH) // ADD, SUB, AND, NOT
	compile_short = {instr.opcode, instr.src, instr.dest};
      else
        $display("%0dt: Instruction of %s is not found", $time, instr.opcode);
   endfunction
      
       // Compile the 2-byte instruction here
   function bit [15:0] compile_long(input Instruction instr);
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
  function string create_instr_str(input Instruction instr);
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
