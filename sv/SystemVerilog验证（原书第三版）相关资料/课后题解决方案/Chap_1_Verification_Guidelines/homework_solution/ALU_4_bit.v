////////////////////////////////////////////////////////////////////
// Purpose: DUT for Chap_1_Verification_Guidelines/homework_solution
// Create an ALU with:
// Input reset
// 4-bit signed inputs, A and B
// 5-bit registered signed output  C
// 4 opcodes
//   i add
//   ii sub 
//   iii bitwise invert input A
//   iv reduction OR input B

// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: ALU_4_bit.v,v $
// Revision 1.1  2011/05/28 14:57:35  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/17 16:39:07  Greg
// Initial check-in
//
////////////////////////////////////////////////////////////////////////////////

`default_nettype none
module ALU_4_bit (
    input wire clk,
    input wire reset,
    input wire [1:0] Opcode,	// The opcode
    input wire signed [3:0] A,	// Input data A in 2's complement
    input wire signed [3:0] B,	// Input data B in 2's complement

    output reg signed [4:0] C // ALU output in 2's complement

		  );

   reg signed [4:0] 	    Alu_out; // ALU output in 2's complement


   localparam 		    Add	           = 2'b00; // A + B
   localparam 		    Sub	           = 2'b01; // A - B
   localparam 		    Not_A	   = 2'b10; // ~A
   localparam 		    ReductionOR_B  = 2'b11; // |B

   // Do the operation
   always @* begin
      case (Opcode)
	Add:            Alu_out = A + B;
	Sub:            Alu_out = A - B;
	Not_A:          Alu_out = ~A;
	ReductionOR_B:  Alu_out = |B;
        default: begin
           Alu_out = 5'b0;
           $display("%t: Error: Opcode of %0b not recognized", Opcode, $time);
        end
      endcase
   end // always @ *

   // Register output C
   always @(posedge clk or posedge reset) begin
      if (reset)
	C <= 5'b0;
      else
	C<= Alu_out;
   end
   

   //synopsys translate_off
   reg [192:0] 		    ASCII_Opcode;
   always @(Opcode) begin
      case (Opcode)
        Add:            ASCII_Opcode = "Add";
        Sub:            ASCII_Opcode = "Sub";
        Not_A:          ASCII_Opcode = "Not_A";
        ReductionOR_B:  ASCII_Opcode = "ReductionOR_B";
        default: begin
           ASCII_Opcode = "ERROR";
           $display("%t: Error: Opcode not recognized", $time);
        end
      endcase
   end
   //synopsys translate_on

endmodule
