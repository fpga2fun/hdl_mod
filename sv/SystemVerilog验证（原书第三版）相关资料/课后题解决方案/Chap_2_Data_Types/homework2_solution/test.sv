//////////////////////////////////////////////////////////////
// Purpose: Testbench for Chap_2_Data_Types/homework2_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/28 19:48:16  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/17 15:58:51  Greg
// Initial check-in
//
//////////////////////////////////////////////////////////////
`default_nettype none
module test;
		       // Declare all inputs as bit
		       bit clk;
		       bit write;
		       bit read;
		       bit [7:0] data_in;
		       bit [15:0] address;
		       logic [8:0] data_out; // Data read


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

   // Error and correct counter
   int error = 0, correct = 0, index;
   
initial begin
   write = 0;
   read = 0;
   
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
   for (int i=0;i<TESTS;i++) begin
      @(negedge clk);
      write = 1;
      data_in =  mem_packet_queue[i].data_in;
      address = mem_packet_queue[i].address;

   end

   @(negedge clk);
   write = 0;
   
   // Shuffle the queue
   mem_packet_queue.shuffle;

   // Do the reads check the results
   for (int i=0;i<TESTS;i++) begin
      @(negedge clk);
      read = 1;
      address = mem_packet_queue[i].address;
      @(posedge clk); // read is complete
      #5ns;
      Check9Bits(mem_packet_queue[i].expected_data, data_out, address);
      mem_packet_queue[i].data_out = data_out;
   end

   @(negedge clk);
   read = 0;

   // Print out the read queue
   for (int i=0;i<TESTS;i++)
     $display("Read a 0x%0h", mem_packet_queue[i].data_out);

   $display("%0t: At end of test error = %0d, correct = %0d", $time, error, correct); 

   $finish;  
   
end // initial begin

   // Instantiate my_mem
   my_mem my_mem(
		 .clk(clk),
		 .write(write),
		 .read(read),
		 .data_in(data_in),
		 .address(address), 
		 .data_out(data_out)
		 );

   // Create a clock
   initial begin
      clk = 1'b0;
      forever #50ns clk=!clk;
   end

   task Check9Bits(input bit [8:0] expected, input logic [8:0] actual, input bit [15:0] address);
      if (expected !== actual) begin
	 $display("%t: Read from address %h expected %h but got %h", $time, address, expected, actual);
	 error = error + 1;
      end
      correct = correct + 1;
   endtask // Check9Bits
   

endmodule // test

