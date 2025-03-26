/////////////////////////////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_7_Threads_and_Interprocess_Communication/exercise3
// Author: Chris Spear
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/29 19:13:44  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/10 23:10:17  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////////////////////////
`default_nettype none
  program automatic test;
   
   import  my_package::*;

   event e1, e2;

   task trigger(event local_event, input time wait_time);
      #wait_time;
      ->local_event;
   endtask // void

   initial begin
      fork 
	 trigger(e1, 10ns);
	 begin
	    wait(e1.triggered());
	    $display("%0t: e1 triggered", $time);
	 end
      join
   end

      initial begin
      fork 
	 trigger(e2, 20ns);
	 begin
	    wait(e2.triggered());
	    $display("%0t: e2 triggered", $time);
	 end
      join
   end
   
   

   
endprogram

