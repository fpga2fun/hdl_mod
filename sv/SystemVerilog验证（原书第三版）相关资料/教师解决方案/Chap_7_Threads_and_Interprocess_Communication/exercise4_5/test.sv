//////////////////////////////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_7_Threads_and_Interprocess_Communication/exercise4_5
// Author: Chris Spear
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/29 19:13:45  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/10 23:17:52  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////////////////////////
`default_nettype none
  program automatic test;
   semaphore sem;

  
   initial begin
      fork 
	 begin
	    sem = new(1);
	    sem.get(1);
	    #45ns;
	    sem.put(2);
	 end
	 wait10;
      join 
   end

   task wait10;
      int i= 10;
      do begin
	 #10ns;
	 i--;
      end
      while ((i!= 0) && !sem.try_get(1));
      $display("%0t: Done at i=%0d", $time, i);
   endtask // wait10
   
 
   
endprogram
