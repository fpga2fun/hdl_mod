///////////////////////////////////////////////////////////////////////////////////////
// Purpose: Testbench for Chap_4_Connecting_the_Testbench_and_Design/homework1_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/28 20:22:58  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/17 14:29:43  Greg
// Initial check in
//
///////////////////////////////////////////////////////////////////////////////////////

`default_nettype none
`include "mem_if.sv"
module test;

   bit clk;
   int index;

   mem_if mem_bus(clk);

   typedef     struct {
		       bit [7:0] data_in;
		       bit [15:0] address;
		       bit [8:0] expected_data;
		       logic [8:0] data_out;
		       } mem_packet;

// Declare a queue of memory packets
   mem_packet mem_packet_queue[$];
   mem_packet mem_packet_single;

   // # of memory locations to test
   localparam  TESTS = 6;

   int correct = 0;

initial begin
   mem_bus.write = 0;
   mem_bus.read = 0;
   mem_bus.error = 0;
   
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
      @(negedge clk);
      mem_bus.write = 1;
      mem_bus.data_in =  mem_packet_queue[index].data_in;
      mem_bus.address = mem_packet_queue[index].address;
      index++;
   end
   while (index != mem_packet_queue.size);

   @(negedge clk);
   mem_bus.write = 0;
   
   // Shuffle the queue
   mem_packet_queue.shuffle;

   // Do the reads check the results
   for (int i=0;i<TESTS;i++) begin
      @(negedge clk);
      mem_bus.read = 1;
      mem_bus.address = mem_packet_queue[i].address;
      @(posedge clk); // read is complete
      #5ns;
      Check9Bits(mem_packet_queue[i].expected_data, mem_bus.data_out,mem_bus. address);
      mem_packet_queue[i].data_out = mem_bus.data_out;
   end

   @(negedge clk);
   mem_bus.read = 0;

   // Print out the read queue
   for (int i=TESTS-1;i>=0;i--)
     $display("Read a 0x%0h", mem_packet_queue[i].data_out);

   // Check the read=1 and write=1 checker
   @(negedge clk);
   mem_bus.read = 1;
   mem_bus.write = 1;
   @(negedge clk);
   mem_bus.read = 0;
   mem_bus.write = 0;

   $display("%0t: At end of test error = %0d and correct = %0d", $time, mem_bus.error, correct);

   $finish;
   
end // initial begin

   // Instantiate my_mem
   my_mem my_mem(mem_bus.slave);

   // Create a clock
   initial begin
      clk = 1'b0;
      forever #50ns clk=!clk;
   end

   task Check9Bits(input bit [8:0] expected, input logic [8:0] actual, input bit [15:0] address);
      if (expected !== actual) begin
	 $display("%t: Read from address 0x%0h expected 0x%0h but got 0x%0h", $time, address, expected, actual);
	 mem_bus.error++;
      end
      else
	correct++;
   endtask // Check9Bits
   

endmodule // test

