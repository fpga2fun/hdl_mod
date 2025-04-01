////////////////////////////////////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_7_Threads_and_Interprocess_Communication/homework2_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/29 19:13:51  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/19 14:44:10  Greg
// Initial check in
//
/////////////////////////////////////////////////////////////////////////////////////////
`default_nettype none
  program automatic test;

   // Uses Producer from Sample 7-39
   mailbox #(int) mbx1;
   mailbox #(int) mbx2;

class Consumer1;
   task run();
      int i;
      repeat (3) begin
	 mbx1.peek(i); // Peek integer from mbx
	 #10ns;
	 $display("%0t: Consumer1: before get(%0d)", $time, i);
	 mbx1.get(i); // Remove from mbx
	 $display("%0t: Consumer1: after get(%0d)", $time, i);
      end
   endtask
endclass // Consumer

class Consumer2;
   task run();
      int i;
      repeat (3) begin
	 mbx2.peek(i); // Peek integer from mbx
	 #10ns;
	 $display("%0t: Consumer2: before get(%0d)", $time, i);
	 mbx2.get(i); // Remove from mbx
	 $display("%0t: Consumer2: after get(%0d)", $time, i);
      end
   endtask
endclass // Consumer

class Producer;
   task run();
      for (int i=1; i<6; i=i+2) begin
	 $display("%0t: Producer: before put(%0d)", $time, i);
	 // This will only work if both consumer's have the same delay
	 mbx1.put(i);
	 $display("%0t: Producer: after put(%0d)", $time, i);
	 $display("%0t: Producer: before put(%0d)", $time, i+1);
	 mbx2.put(i+1);
	 $display("%0t: Producer: after put(%0d)", $time, i+1);
      end
   endtask
endclass // Producer

   Producer p;
Consumer1 c1;
   Consumer2 c2;

   initial begin
      // Construct mailbox, producer, consumer
      mbx1 = new(1); // Bounded mailbox - limit 1!
      mbx2 = new(1);
      
      p = new();
      c1 = new();
      c2 = new();
      // Run the producer and consumer in parallel
      fork
	 p.run();
	 c1.run();
	 c2.run();
      join
   end
endprogram
