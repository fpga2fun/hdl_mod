////////////////////////////////////////////////////////////
// Purpose: Testbench for Chap_2_Data_Types/homework1_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/28 19:48:15  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/17 16:14:12  Greg
// Initial check-in
//
////////////////////////////////////////////////////////////

`default_nettype none
module test;
   bit [15:0] address_array []; // Dynamic array of addresses
   bit [7:0]  data_to_write_array[]; // Dynamic array of data to write
   bit [8:0] data_read_expect_assoc[int]; // Associative array of data expected to be read indexed by address
   logic [8:0] data_read_queue[$]; // Queue of data read

   // Declare all inputs as bit
   bit clk;
   bit write;
   bit read;
   bit [7:0] data_in;
   bit [15:0] address;

   // Declare the output as 4-value logic
   logic [8:0] data_out;

   // # of memory locations to test
   localparam  TESTS = 6;

   // Error and correct counter
   int error = 0, correct = 0;
   
initial begin
   write = 0;
   read = 0;
   
   // Allocate TESTS addresses for the address and data to write dynamic array 
   address_array = new[TESTS];
   data_to_write_array = new[TESTS];
   
   // Fill the address dynamic array with 6 random addresses to write and then read
   for (int i=0;i<TESTS;i++) begin
     address_array[i] = $random;
   end
   
   // fill the data to write dynamic array with 6 random data words
   for (int i=0;i<TESTS;i++) begin
     data_to_write_array[i] = $random;
   end

   // Traverse the data to write dynamic array and create data_read_expect_assoc
   // Remember that the MSB is the even parity bit
   for (int i=0;i<TESTS;i++) begin
      data_read_expect_assoc[address_array[i]] = ({^data_to_write_array[i], data_to_write_array[i]});
   end
   
   // ------ Do the test -------
   // Do the writes
   for (int i=0;i<TESTS;i++) begin
      @(negedge clk);
      write = 1;
      address = address_array[i];
      data_in = data_to_write_array[i];
   end

   @(negedge clk);
   write = 0;
   
   // Do the reads in reverse order and check the results
   for (int i=TESTS-1;i>=0;i--) begin
      @(negedge clk);
      read = 1;
      address = address_array[i];
      @(posedge clk); // read is complete
      #5ns;
      Check9Bits(data_read_expect_assoc[address], data_out, address);
      data_read_queue.push_back(data_out);
   end

   @(negedge clk);
   read = 0;

   // Print out the read queue
   $display("Elements in data_read_queue are:");
   while (data_read_queue.size != 0)
     $displayh(data_read_queue.pop_front); 

   $display("%0t: At end of test error = 0d%0d and correct = 0d%0d", $time, error, correct); 
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
      forever #50ns clk=!clk;
   end

   task Check9Bits(input bit [8:0] expected, input logic [8:0] actual, input bit [15:0] address);
      if (expected !== actual) begin
	 $display("%t: Read from address 0x%0h expected 0x%0h but got 0x%0h", $time, address, expected, actual);
	 error = error + 1;
      end
      correct = correct + 1;
   endtask // Check9Bits
   

endmodule // test

