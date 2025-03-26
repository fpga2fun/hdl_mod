////////////////////////////////////////////////////////////////
// Purpose: Simulus for Chap_9_Functional_Coverage/exercise3_4
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.3  2011/09/15 20:15:05  tumbush.tumbush
// Replaced opcode_t with opcode_e
//
// Revision 1.2  2011/09/15 19:17:48  tumbush.tumbush
// Replaced assert with SV_RAND_CHECK
//
// Revision 1.1  2011/05/29 19:24:36  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/12 15:35:04  Greg
// Initial check-in
//
////////////////////////////////////////////////////////////////
`default_nettype none
`include "SV_RAND_CHECK.sv"
  program automatic test(busifc.TB ifc);

   typedef enum {ADD, SUB, MULT, DIV} opcode_e;

   opcode_e local_opcode;
   
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
      coverpoint tr.opcode{
	 bins add_sub = {ADD, SUB};
	 bins add_then_sub = (ADD=>SUB);
	 illegal_bins no_div = {DIV};
      }     
   endgroup
   
   initial begin
      CovCode ck;
      ck = new(); // Instantiate group
      tr = new();
      repeat (32) begin // Run a few cycles
	 `SV_RAND_CHECK(tr.randomize); // Create a transaction
	 local_opcode = tr.opcode;
	 @ifc.cb; // Wait a cycle
      end
   end // initial begin


endprogram // automatic
   
