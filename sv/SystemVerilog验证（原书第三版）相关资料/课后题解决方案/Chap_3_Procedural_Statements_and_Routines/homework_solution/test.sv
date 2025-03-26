/////////////////////////////////////////////////////////////////////////////////////
// Purpose: Testbench for Chap_3_Procedural_Statements_and_Routines/homework_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/28 20:06:48  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/17 15:01:01  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////////////////////////////

`default_nettype none 
module test;

   bit clk;
   bit read;
   bit write;
   int index;
   int error=0; // Error counter
   int correct = 0; // Correct counter
   bit [7:0] data_in;
   bit [15:0] address;

   typedef     struct {
		       bit [7:0] data_in;
		       bit [15:0] address;
		       bit [8:0] expected_data;
		       logic [8:0] data_out;
		       } mem_packet;

// Declare a queue of memory packets
   mem_packet mem_packet_queue[$];
   mem_packet mem_packet_single;

    // Declare the output as 4-value logic
   logic [8:0] data_out;

  // # of memory locations to test
   localparam  TESTS = 6;

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
   index = 0;
   do begin
      @(negedge clk);
      write = 1;
      data_in =  mem_packet_queue[index].data_in;
      address = mem_packet_queue[index].address;
      index++;
   end
   while (index != mem_packet_queue.size);

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
   for (int i=TESTS-1;i>=0;i--)
     $display("Read a %h", mem_packet_queue[i].data_out);

   // Check the read=1 and write=1 checker
   @(negedge clk);
   read = 1;
   write = 1;
   @(negedge clk);
   read = 0;
   write = 0;

   $display("%t: At end of test errors = %0d and correct = %0d", $time, error, correct);
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
	 $display("%t: Read from address %0h expected %0h but got %0h", $time, address, expected, actual);
	 error++;
      end
      else
	correct++;
   endtask // Check9Bits

      // make sure read and write are not both asserted 
   always @(posedge clk) begin
      if (read && write) begin
	$display("Error: read and write are both asserted");
	 error++;
      end
   end


endmodule // test

