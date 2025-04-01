////////////////////////////////////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_7_Threads_and_Interprocess_Communication/homework2_problem
//          Uses Producer/Consumer from Sample 7-40 as a starting point.
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/29 19:13:49  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.2  2011/03/19 14:31:54  Greg
// Updated upper range of for loop so 3 ints are produced.
//
// Revision 1.1  2011/03/19 14:27:05  Greg
// Initial check in
//
/////////////////////////////////////////////////////////////////////////////////////////

`default_nettype none
  program automatic test;

   mailbox #(int) mbx;

   class Consumer;
      task run();
         int i;
         repeat (3) begin
   	 mbx.peek(i); // Peek integer from mbx
   	 #10ns;
   	 $display("%0t: Consumer: before get(%0d)", $time, i);
   	 mbx.get(i); // Remove from mbx
   	 $display("%0t: Consumer: after get(%0d)", $time, i);
         end
      endtask
   endclass // Consumer

   class Producer;
      task run();
         for (int i=1; i<=3; i++) begin
   	 $display("%0t: Producer: before put(%0d)", $time, i);
   	 mbx.put(i);
   	 $display("%0t: Producer: after put(%0d)", $time, i);
         end
      endtask
   endclass // Producer
   
   Consumer c;
   Producer p;
   initial begin
      // Construct mailbox, producer, consumer
      mbx = new(1); // Bounded mailbox - limit 1!
      p = new();
      c = new();

      // Run the producer and consumer in parallel
      fork
	 p.run();
	 c.run();
      join
   end
endprogram
