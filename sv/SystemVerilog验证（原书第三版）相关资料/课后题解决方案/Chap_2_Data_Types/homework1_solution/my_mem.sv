/////////////////////////////////////////////////////////////////
// Purpose: Memory model for Chap_2_Data_Types/homework1_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: my_mem.sv,v $
// Revision 1.1  2011/05/28 19:48:15  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.3  2011/05/04 18:11:09  Greg
// Declared input logic clk as type var
//
// Revision 1.2  2011/03/20 18:40:54  Greg
// Updated input declaration to add the var keyword which is required for
// use with `default_nettype none
//
// Revision 1.1  2011/03/17 16:14:12  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////////
`default_nettype none
  module my_mem(
		input  var logic clk,
		input  var logic write,
		input  var logic read,
		input  var logic [7:0] data_in,
		input  var logic [15:0] address,
		output logic [8:0] data_out
);

   // Declare a 9-bit associative array using the logic data type
   logic [8:0] mem_array[int];

   always @(posedge clk) begin
      if (write)
        mem_array[address] = {^data_in, data_in};
      else if (read)
	data_out =  mem_array[address];
   end

endmodule // test

