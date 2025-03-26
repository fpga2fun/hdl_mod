///////////////////////////////////////////////////////
// Purpose: testbench for Chap_2_Data_Types/exercise11
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.2  2011/09/08 20:09:11  tumbush.tumbush
// Added 2nd solution using an enumerated loop variable.
//
// Revision 1.1  2011/05/28 19:48:06  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/05 22:22:55  Greg
// Initial check-in
//
/////////////////////////////////////////////////////

//  Note: Will get a warning like: # ** Warning: (vsim-3015) 
// test.sv(26): [PCDPC] - Port size (2 or 2) does not match 
// connection size (32) for port 'opcode'. The port definition 
// is at: alu.v(3).
// This can be fixed by specifying the bits of opcode to use 
// when instantiating alu
`default_nettype none
  module test;

   // Create an enumerated type of the opcodes, opcode_t
   typedef enum {Add, Sub, Not_A, ReductionOR} opcode_t;

   // Create a variable, opcodes, of type opcode_t
   opcode_t opcode;
   
   initial begin
      // Loop through all the values of variable opcode every 10ns
       // Solution 1 but note that an int instead of an enumerated 
         // loop variable is used.
      for (int i=0;i<opcode.last+1;i++) begin
	 $display("opcode = %s", opcode);
	 #10ns;
	 opcode = opcode.next(1);
      end
      
      /*
      // Solution 2 using an enumerated loop variable
      opcode = opcode.first();
      do
	begin
	   $display("opcode = %s", opcode);
	   opcode = opcode.next(1);
	   #10ns;
	end
      while (opcode != opcode.first()); 
      */

      #10ns;
      $finish;
   end

   // Instantiate an ALU with 1 2-bit input opcode
   alu alu(.opcode(opcode));
   // alu alu(.opcode(opcode[1:0])); // Fixes warning


endmodule // test

