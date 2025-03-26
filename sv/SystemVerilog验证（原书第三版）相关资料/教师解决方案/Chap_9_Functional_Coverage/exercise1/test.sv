////////////////////////////////////////////////////////////////
// Purpose: Simulus for Chap_9_Functional_Coverage/exercise1
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.2  2011/09/15 19:14:59  tumbush.tumbush
// Replaced assert wtih SV_RAND_CHECK
//
// Revision 1.1  2011/05/29 19:24:34  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/12 15:16:27  Greg
// Initial check-in
//
////////////////////////////////////////////////////////////////
`default_nettype none
`include "SV_RAND_CHECK.sv"
  program automatic test(busifc.TB ifc);

   typedef enum {ADD, SUB, MULT, DIV} opcode_e; 
   
class Transaction;
   rand opcode_e opcode;
   rand int operand1;
   rand int operand2;
endclass // Transaction
   
   Transaction tr;

   covergroup CovCode @ifc.cb;
      coverpoint tr.opcode;
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
   
