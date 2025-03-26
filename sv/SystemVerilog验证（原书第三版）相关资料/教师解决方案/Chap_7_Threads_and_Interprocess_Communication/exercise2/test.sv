/////////////////////////////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_7_Threads_and_Interprocess_Communication/exercise2
// Author: Chris Spear
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/29 19:13:43  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/10 23:04:25  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////////////////////////
`default_nettype none

  program automatic test;
   
   initial begin
	fork	   transmit(1);	   transmit(2); 	join_none

        fork: receive_fork
          receive(1);
          receive(2);
	join_none

        wait fork;

      #15ns disable receive_fork;
      $display("%0t: Done", $time);
   end

   task transmit(int index);
      #10ns;
      $display("%0t: Transmit is done for index = %0d", $time, index);
   endtask // transmit

   task receive(int index);
      #(index * 10ns);
      $display("%0t: Receive is done for index = %0d", $time, index);
   endtask // automatic

endprogram
 
