//////////////////////////////////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_4_Connecting_the_Testbench_and_Design/homework2_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/28 20:22:59  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/17 14:08:51  Greg
// Initial check in
//
//////////////////////////////////////////////////////////////////////////////////////
program automatic test(mem_if mem_bus);

   typedef     struct {
		       bit [7:0] data_in;
		       bit [15:0] address;
		       bit [8:0] expected_data;
		       logic [8:0] data_out;
		       } mem_packet;

   int index, error, correct;
   bit begin_read = 0;

// Declare a queue of memory packets
   mem_packet mem_packet_queue[$];
   mem_packet mem_packet_single;

   // # of memory locations to test
   localparam  TESTS = 6;

initial begin
   mem_bus.cb.write <= 0;
   mem_bus.cb.read <= 0;
   error = 0;
   correct = 0;
   
   // Fill the address field with 6 random addresses to write and then read
   // Fill the data_in field with 6 random data values to write
   // Fill the expected_data field with the expected value to read
   // Push the single packet onto the queue
   for (int i=0;i<TESTS;i++) begin
     mem_packet_single.address = $random;
     mem_packet_single.data_in = $random;
     mem_packet_single.expected_data = {^mem_packet_single.data_in, mem_packet_single.data_in};
     mem_packet_queue.push_back(mem_packet_single);
   end
   
   
   // ------ Do the test -------
   // Do the writes
   index = 0;
   do begin
      @mem_bus.cb;
      mem_bus.cb.write <= 1;
      mem_bus.cb.data_in <=  mem_packet_queue[index].data_in;
      mem_bus.cb.address <= mem_packet_queue[index].address;
      index++;
   end
   while (index != mem_packet_queue.size);

   @mem_bus.cb;
   mem_bus.cb.write <= 0;
   
   // Shuffle the queue
   mem_packet_queue.shuffle;

   // Do the reads
   begin_read = 1;
   for (int i=0;i<TESTS;i++) begin
      mem_bus.cb.read <= 1;
      mem_bus.cb.address <= mem_packet_queue[i].address;
      @mem_bus.cb; // read is complete
   end

   @mem_bus.cb;
   mem_bus.cb.read <= 0;

   // Check the read=1 and write=1 checker
   mem_bus.cb.read <= 1;
   mem_bus.cb.write <= 1;
   @(mem_bus.cb);
   mem_bus.cb.read <= 0;
   mem_bus.cb.write <= 0;
   @(mem_bus.cb);

   $display("%0t: At end of test error = %0d and correct = %0d", $time, error, correct);  
   $finish; 
   
end // initial begin

// Check the result of the reads
initial begin
   @(begin_read);
   @mem_bus.cb;
   for (int i=0;i<TESTS;i++) begin
      @mem_bus.cb;
      Check9Bits(mem_packet_queue[i].expected_data, mem_bus.cb.data_out,mem_packet_queue[i].address);
      mem_packet_queue[i].data_out = mem_bus.cb.data_out;
   end

   // Print out the read queue
   for (int i=TESTS-1;i>=0;i--)
     $display("Read a 0x%0h", mem_packet_queue[i].data_out);

end

   task Check9Bits(input bit [8:0] expected, input logic [8:0] actual, input bit [15:0] address);
      if (expected !== actual) begin
	 $display("%0t: Error: Read from address 0x%0h expected 0x%0h but got 0x%0h", $time, address, expected, actual);
	 error++;
      end   
      else begin
          $display("%0t: Pass: Read from address 0x%0h and got 0x%0h", $time, address, expected);
	 correct++;
      end
   endtask // Check9Bits

endprogram
