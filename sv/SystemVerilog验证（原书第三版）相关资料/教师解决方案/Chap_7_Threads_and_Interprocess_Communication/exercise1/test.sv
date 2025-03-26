/////////////////////////////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_7_Threads_and_Interprocess_Communication/exercise1
// Author: Chris Spear
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/29 19:13:41  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/10 23:00:09  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////////////////////////


`default_nettype none
  program automatic test;
   
   initial begin
      $display("@%0t: start fork...join_none example", $time);
      fork
	 begin
	    #20 $display("@%0t: sequential A after #20", $time);
	    #20 $display("@%0t: sequential B after #20", $time);
	 end	 
	 $display("@%0t: parallel start", $time);
	 #50 $display("@%0t: parallel after #50", $time);
	 begin
	    #30 $display("@%0t: sequential after #30", $time);
	    #10 $display("@%0t: sequential after #10", $time);
	 end
      join
      // join_none
      // join_any
      $display("@%0t: after join", $time);
      #80 $display("@%0t: finish after #80", $time);
   end
   
endprogram

