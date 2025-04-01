/////////////////////////////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_7_Threads_and_Interprocess_Communication/exercise6
// Author: Chris Spear
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/29 19:13:46  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/10 23:23:11  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////////////////////////
`default_nettype none
  program automatic test;
   mailbox #(int) mbx;
   int 	   value;
   
   initial begin
      mbx = new(1);
      $display("mbx.num()=%0d", mbx.num());
      $display("mbx.try_get= %0d", mbx.try_get(value));
      mbx.put(2);
      $display("mbx.try_put= %0d", mbx.try_put(value));
      $display("mbx.num()=%0d", mbx.num());
      mbx.peek(value);
      $display("value=%0d", value);        
   end

endprogram
