//////////////////////////////////////////////////////
// Purpose: DUT for Chap_5_Basic_OOP/homework_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: my_mem.sv,v $
// Revision 1.1  2011/05/29 19:03:55  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/20 19:02:27  Greg
// Initial check in
//
///////////////////////////////////////////////////////
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

