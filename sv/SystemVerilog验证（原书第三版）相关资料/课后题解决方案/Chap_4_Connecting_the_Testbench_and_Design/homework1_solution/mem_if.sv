//////////////////////////////////////////////////////////////////////////////////////////////
// Purpose: Memory interface for Chap_4_Connecting_the_Testbench_and_Design/homework1_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: mem_if.sv,v $
// Revision 1.1  2011/05/28 20:22:58  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/17 14:29:43  Greg
// Initial check in
//
//////////////////////////////////////////////////////////////////////////////////////////////

interface mem_if (input bit clk);
                int error; // Error needs to be in/out
		bit write;
		bit read;
		bit [7:0] data_in;
		bit [15:0] address;
    	        logic [8:0] data_out;

   modport slave (input clk, write, read, data_in, address,
              output data_out, import parity);


   // make sure read and write are not both asserted 
   always @(posedge clk) begin
      if (read && write) begin
	$display("%0t: Error: read and write are both asserted", $time);
	 error++;
      end
   end

   function automatic parity(input [7:0] data_in);
      parity = ^mem_bus.data_in;
   endfunction
 
   
   
endinterface
