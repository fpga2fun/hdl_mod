////////////////////////////////////////////////////////////////
// Purpose: SystemVerilog code for Chap_2_Data_Types/exercise8
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.2  2011/09/07 16:31:46  tumbush.tumbush
// Updated as per new exercise statement.
//
// Revision 1.1  2011/05/28 19:48:13  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/05 22:32:34  Greg
// Initial check-in
//
////////////////////////////////////////////////////////////////


`default_nettype none
  module test;

   // a) Create a 3-byte queue and initialize it with 1, -1, and 127
   // byte byte_queue[$] = {8'sh02, 8'shFF, 8'sh7F}; // Signed values
   // byte byte_queue[$] = {8'sh2, -8'sh01, 8'sh7F}; // Signed values
   // byte byte_queue[$] = {8'h02, 8'hFF, 8'h7F}; // Signed values
   // byte byte_queue[$] = {8'h2, -8'h01, 8'h7F}; // Signed values
   byte byte_queue[$] = {2, -1, 127}; // Signed values


   initial begin
    // b) Print out the sum of the queue in decimal
    $display("byte_queue.sum = 0d%0d", byte_queue.sum() with (int'(item)));

      // c) Print out the min and max in the queue
      $display("byte_queue.min = %p", byte_queue.min); // # byte_queue.min = '{-1}
      $display("byte_queue.max = %p", byte_queue.max); // # byte_queue.max = '{127}

      // d) Sort all values in the queue and print out the resulting queue
      byte_queue.sort;
      $display("byte_queue.sort = %p",  byte_queue); // # byte_queue.sort = '{-1, 1, 127}
      // $display("byte_queue.sort = %p",  byte_queue.sort); // Compiler error since return type is void.
      
      // e) Print out the index of any negative values in the queue
      $display("byte_queue.find_index with (item <0) = %p",  byte_queue.find_index with (item <0)); // # byte_queue.find_index with (item <0) = '{0} 

      // f) Print the positive values in the queue
      $display("byte_queue.find with (item >=0) = %p",  byte_queue.find with (item >=0)); // # byte_queue.find with (item >=0) = '{1, 127}

      // g) Reverse sort all values in the queue and print out the resulting queue
      byte_queue.rsort;
      $display("byte_queue.rsort = %p",  byte_queue); // # byte_queue.rsort = '{127, 1, -1}
      $finish;
   end
   
endmodule // test

