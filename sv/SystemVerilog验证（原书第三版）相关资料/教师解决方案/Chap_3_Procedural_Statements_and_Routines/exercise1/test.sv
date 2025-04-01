////////////////////////////////////////////////////////////////////////////
// Purpose: Solution for Chap_3_Procedural_Statements_and_Routines/exercise1
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.3  2011/09/15 15:01:29  tumbush.tumbush
// Pre-decrment address. Write my_array[511]=5
//
// Revision 1.2  2011/09/15 02:27:39  tumbush.tumbush
// Showed that I can declare my_array[512] also.
//
// Revision 1.1  2011/05/28 20:06:42  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/08 20:35:55  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////////////////////
`default_nettype none
module test;

   // a) Create a 512 element integer array
   // int my_array[511:0];
   int my_array[512];
   
   // b) Create a 9-bit address variable to index into the array 
   bit [8:0] address; // Initialized to 0 because of type bit.

   // c) Initialize the last location of the array to 5
   // d) Call a task, my_task, and pass the array and the address
   initial begin
      my_array[511] = 5;
      my_task(my_array, address);
      $finish;
   end

   // e) Create my_task() that takes 2 inputs, a constant 512-element 
   //    integer array passed by reference, and a 9-bit address. The task calls
   //    a function,  print_int(), passes the array element, indexed by the address, 
   // to the function, pre-decrementing the address."
   // task automatic my_task(const ref int my_array[511:0], input bit [8:0] address);
   task automatic my_task(const ref int my_array[512], input bit [8:0] address);
      print_int(my_array[--address]);
       // $display("address = 0d%0d", address);
   endtask // my_task
   
   // f) Create a function that prints out the simulation time and the value of 
   //    the input.  The function has no return value
   function void print_int(input int input_val);
      $display("At %0t input_val = %0d", $time, input_val);
   endfunction // int

endmodule // test

