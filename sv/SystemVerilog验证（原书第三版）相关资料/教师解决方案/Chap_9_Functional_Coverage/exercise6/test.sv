////////////////////////////////////////////////////////////////
// Purpose: Simulus for Chap_9_Functional_Coverage/exercise6
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.2  2011/09/15 19:19:40  tumbush.tumbush
// Replaced assert with SV_RAND_CHECK
//
// Revision 1.1  2011/05/29 19:24:38  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/12 15:41:28  Greg
// Initial check-in
//
////////////////////////////////////////////////////////////////
`default_nettype none
`include "SV_RAND_CHECK.sv"

  program automatic test(busifc.TB ifc);

   typedef enum {ADD, SUB, MULT, DIV} opcode_t;

   opcode_t local_opcode;
   
class Transaction;
   rand opcode_t opcode;
   rand byte operand1;
   rand byte operand2;
endclass // Transaction
   
   Transaction tr;

   covergroup CovCode @ifc.cb;
      type_option.merge_instances = 1; // to show bins 
      operand1_cp: coverpoint tr.operand1{
         bins max_neg = {-128};
         bins zero = {0};
         bins max_pos = {127};
         bins misc = default;
      }       
      opcode_cp: coverpoint tr.opcode{
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
      $display("%t: Coverpoint ck.operand1_cp coverage is %f", $time, ck.operand1_cp.get_coverage());
      $display("%t: Covergroup CovCode::opcode_cp is %f", $time, CovCode::opcode_cp.get_coverage());

   end // initial begin


endprogram // automatic
   
