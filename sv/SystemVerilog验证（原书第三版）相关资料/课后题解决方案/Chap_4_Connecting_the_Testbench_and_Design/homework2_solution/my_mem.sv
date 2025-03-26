////////////////////////////////////////////////////////////////////////////////////
// Purpose: DUT for Chap_4_Connecting_the_Testbench_and_Design/homework2_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: my_mem.sv,v $
// Revision 1.1  2011/05/28 20:22:59  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/17 14:08:51  Greg
// Initial check in
//
////////////////////////////////////////////////////////////////////////////////////
`default_nettype none
  module my_mem(mem_if mem_bus);

   // Declare a 9-bit associative array using the logic data type
   logic [8:0] mem_array[int];

   always @(posedge mem_bus.clk) begin
      if (mem_bus.write)
	mem_array[mem_bus.address] = {mem_bus.parity(.data_in(mem_bus.data_in)), mem_bus.data_in};
      else if (mem_bus.read)
	mem_bus.data_out = mem_array[mem_bus.address];
	// mem_bus.data_out = #75ns mem_array[mem_bus.address];
   end

endmodule // test

