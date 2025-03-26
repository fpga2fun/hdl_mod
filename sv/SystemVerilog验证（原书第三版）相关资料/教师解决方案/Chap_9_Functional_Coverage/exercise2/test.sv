////////////////////////////////////////////////////////////////
// Purpose: Simulus for Chap_9_Functional_Coverage/exercise2
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.3  2011/09/15 19:31:37  tumbush.tumbush
// Replace opcode_t with opcode_e
//
// Revision 1.2  2011/09/15 19:16:41  tumbush.tumbush
// Replace assert with SV_RAND_CHECK
//
// Revision 1.1  2011/05/29 19:24:35  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/12 15:31:59  Greg
// Initial check-in
//
////////////////////////////////////////////////////////////////
`default_nettype none
`include "SV_RAND_CHECK.sv"
  program automatic test(busifc.TB ifc);

   typedef enum {ADD, SUB, MULT, DIV} opcode_e; 
   
class Transaction;
   rand opcode_e opcode;
   rand byte operand1;
   rand byte operand2;
endclass // Transaction
   
   Transaction tr;

   covergroup CovCode @ifc.cb;
      coverpoint tr.operand1{
         bins max_neg = {-128};
         bins zero = {0};
         bins max_pos = {127};
         bins misc = default;
      }            
   endgroup
   
   initial begin
      CovCode ck;
      ck = new(); // Instantiate group
      tr = new();
      repeat (32) begin // Run a few cycles
	 `SV_RAND_CHECK(tr.randomize); // Create a transaction
	 @ifc.cb; // Wait a cycle
      end
   end // initial begin


endprogram // automatic
   
