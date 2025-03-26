///////////////////////////////////////////////////////////////////////////
// Purpose: Testbench for Chap_1_Verificat ion_Guidelines/homework_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: ALU_4_bit_tb.sv,v $
// Revision 1.1  2011/05/28 14:57:35  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/17 16:39:07  Greg
// Initial check-in
//
///////////////////////////////////////////////////////////////////////////

`default_nettype none
module ALU_4_bit_tb;


   // inputs to instantiated ALU
   reg clk, reset;
   reg  signed [3:0] A;	// Input data A: 2's complement
   reg  signed [3:0] B;	// Input data B: 2's complement

   // Output of ALU
   wire signed [4:0] C; // ALU output: 2's complement

   integer 	     error_count; // 32-bit signed

   integer 	     correct_count; // 32-bit signed

   localparam Add = 2'b00,
	      Sub = 2'b01,
	      Not_A = 2'b10,
	      ReductionOR_B = 2'b11;
       
   localparam 	     MAXPOS = 7,
		     ZERO   = 0,
                     MAXNEG = -8;

   reg [1:0] Opcode;	// The opcode

   ALU_4_bit ALU_4_bit (
			.clk(clk),
			.reset(reset),
			.Opcode(Opcode),	 // The opcode
			.A(A),	 // Input data A: signed
			.B(B),	 // Input data B: signed

			.C(C)        // ALU output: signed
			);

   // Create the clock and reset

   initial begin
      clk = 0;
      forever #50 clk = !clk;
   end

      
   
   // Create the Opcode and A and B
   initial begin
      error_count = 0;
      correct_count = 0;

      assert_reset;
      
      // Apply all permutations of max pos, max neg, and 0 to each opcode
      A=MAXNEG; B=MAXNEG;
      Opcode = Add;
      check_result(Opcode, A, B, -16);
      Opcode = Sub;
      check_result(Opcode, A, B, ZERO);

      A=MAXNEG; B=ZERO;
      Opcode = Add;
      check_result(Opcode, A, B, MAXNEG);
      Opcode = Sub;
      check_result(Opcode, A, B, MAXNEG);

      A=MAXNEG; B=MAXPOS;
      Opcode = Add;
      check_result(Opcode, A, B, -1);
      Opcode = Sub;
      check_result(Opcode, A, B, -15);

      A=ZERO; B=MAXNEG;
      Opcode = Add;
      check_result(Opcode, A, B, MAXNEG);
      Opcode = Sub;
      check_result(Opcode, A, B, 8);
      
      A=ZERO; B=ZERO;
      Opcode = Add;
      check_result(Opcode, A, B, ZERO);
      Opcode = Sub;
      check_result(Opcode, A, B, ZERO);

      A=ZERO; B=MAXPOS;
      Opcode = Add;
      check_result(Opcode, A, B, MAXPOS);
      Opcode = Sub;
      check_result(Opcode, A, B, -7);

      A=MAXPOS; B=MAXNEG;
      Opcode = Add;
      check_result(Opcode, A, B, -1);
      Opcode = Sub;
      check_result(Opcode, A, B, 15);
      
      A=MAXPOS; B=ZERO;
      Opcode = Add;
      check_result(Opcode, A, B, MAXPOS);
      Opcode = Sub;
      check_result(Opcode, A, B, MAXPOS);

      A=MAXPOS; B=MAXPOS;
      Opcode = Add;
      check_result(Opcode, A, B, 14);
      Opcode = Sub;
      check_result(Opcode, A, B, ZERO);

      // Set B to non-all 0 and non-all 1.  Apply all 0 and all 1'ss to bitwise invert input A opcode.
      Opcode = Not_A;
      
      A=4'b0000; B=4'b0101;
      check_result(Opcode, A, B, 5'b11111);
      A=4'b1111; B=4'b1010;
      check_result(Opcode, A, B, 5'b00000);

      // Apply 0, all 1's, and walking 1's to B for ReductionOR_B opcode. Set A to a value that will yield the opposite result.
      Opcode = ReductionOR_B;

      A=4'b1111; B=4'b0000;
      check_result(Opcode, A, B, 0);
      A=4'b0000; B=4'b1111;
      check_result(Opcode, A, B, 1);      
      A=4'b0000; B=4'b0001;
      check_result(Opcode, A, B, 1);
      A=4'b0000; B=4'b0010;
      check_result(Opcode, A, B, 1);
      A=4'b0000; B=4'b0100;
      check_result(Opcode, A, B, 1);
      A=4'b0000; B=4'b1000;
      check_result(Opcode, A, B, 1);

      // Set the operands and walk through the opcodes
      A=4'b0101; B=4'b1010;
      Opcode = Add;
      check_result(Opcode, A, B, -1);
      Opcode = Sub;
      check_result(Opcode, A, B, 11);
      Opcode = Not_A;
      check_result(Opcode, A, B, 5'b11010);
      Opcode = ReductionOR_B;
      check_result(Opcode, A, B, 1);

      // Apply inputs so that C is all 1's. Reset
      Opcode = Not_A;
      
      A=4'b0000; B=4'b0101;
      check_result(Opcode, A, B, 5'b11111);

      assert_reset;

      // After reset is released and a postitive clock edge occurs, check the expected value again.
      check_result(Opcode, A, B, 5'b11111);

      $display("%t: At end of test error count is %0d and correct count = %0d", $time, error_count, correct_count);  
      $finish; 
   end

   task check_result (input [1:0] Opcode, input signed [3:0] A, B, input signed [4:0] expected_result);
      @(negedge clk);
      if (expected_result !== C) begin
	 error_count = error_count + 1;
	 $display("%t: Error: For Opcode = %0b, A= 0d%0d, and B=0d%0d C should equal 0d%0d but is 0d%0d ", $time, Opcode, A, B, expected_result, C);
      end
      else
	correct_count = correct_count + 1;
   endtask

   task checkC(input signed [4:0] expected_C);
      @(negedge clk);
      if (expected_C !== C) begin
	 error_count = error_count + 1;
	 $display("%t: Error: C should equal 0d%0d but the calcuated result is 0d%0d ", $time, expected_C, C);
      end
   endtask // checkC

   task assert_reset;
      reset = 0;
      @(negedge clk);
      reset = 1;
      repeat(5) @(negedge clk);
      // Check reset value of C
      checkC(5'b0);
      reset = 0;
   endtask // assert_reset
   
 
   
endmodule
