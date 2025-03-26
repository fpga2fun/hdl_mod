/////////////////////////////////////////////////////////////////
// Purpose: Memory model for Chap_2_Data_Types/homework2_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: my_mem.sv,v $
// Revision 1.1  2011/05/28 19:48:16  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/17 15:58:51  Greg
// Initial check-in
//
////////////////////////////////////////////////////////////////

  module my_mem(
		input  logic clk,
		input  logic write,
		input  logic read,
		input  logic [7:0] data_in,
		input  logic [15:0] address,
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

