///////////////////////////////////////////////////////////
// Purpose: Package for Chap_5_Basic_OOP/homework_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: my_package.sv,v $
// Revision 1.1  2011/05/29 19:03:55  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/20 19:02:27  Greg
// Initial check in
//
///////////////////////////////////////////////////////////
package my_package;
   
class Transaction;
   static int error = 0, correct = 0;
   bit [7:0] data_in;
   bit [15:0] address;
   bit [8:0]  expected_data;
   logic [8:0] data_out;

   function new();
      address = $random;
      data_in = $random;
      expected_data = {^data_in, data_in};
   endfunction // new

   function void print_data_out;
      $display("%0t: Read a 0x%0h", $time, data_out);
   endfunction //

   function void Check9Bits;
      if (expected_data !== data_out) begin
	 $display("%0t: Error: Read from address 0x%0h expected 0x%0h but got 0x%0h", $time, address, expected_data, data_out);
	 error++;
      end   
      else begin
       // $display("%0t: Pass: Read from address 0x%0h and got 0x%0h", $time, address, expected_data);
	 correct++;
      end
   endfunction // Check9Bits

   function Transaction copy();
      copy = new();
      copy.data_in = data_in;
      copy.address = address;
      copy.expected_data = expected_data;
      copy.data_out = data_out;
   endfunction // copy

   static function void print_error();
      $display("%0t: Error = %0d and correct = %0d", $time, error, correct);
   endfunction

endclass // Transaction


endpackage
