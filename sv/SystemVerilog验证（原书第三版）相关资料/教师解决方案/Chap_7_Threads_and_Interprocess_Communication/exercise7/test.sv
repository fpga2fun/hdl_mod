//////////////////////////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_7_Threads_and_Interprocess_Communicaton/exercise7
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.2  2011/10/26 16:20:12  tumbush.tumbush
// Type the mailbox
//
// Revision 1.1  2011/05/29 19:13:47  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/10 23:26:07  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////////////////
`default_nettype none
  program automatic test(my_if my_bus);
   
class OutputTrans;
   bit out1;
   bit out2;
endclass

class Monitor;
   OutputTrans tr;
   mailbox #(OutputTrans) mbx;
   function new(mailbox #(OutputTrans) mbx);
      this.mbx = mbx;
   endfunction
   task run();
      forever begin
	 tr = new();
         @my_bus.cb;
         tr.out1= my_bus.cb.out1;
         tr.out2 = my_bus.cb.out2;
	 mbx.put(tr);
	 $display("%0t: Put object with out1=%0b and out2=%0b into mailbox", $time, tr.out1, tr.out2);
      end
   endtask
endclass // Monitor

class Environment;
   Monitor mon;
   mailbox #(OutputTrans) mon2chk;

   function void build;
      mon2chk = new(); // unbounded
      mon = new(mon2chk);
   endfunction // void
   
   task run();
      fork 
	 mon.run(); // Run transactor
	 begin
	    #500ns;
	    $finish;
	 end
      join
   endtask // run

endclass // Environment

   Environment env;

   initial begin
      env = new();
      env.build;
      env.run;
   end

   
endprogram

