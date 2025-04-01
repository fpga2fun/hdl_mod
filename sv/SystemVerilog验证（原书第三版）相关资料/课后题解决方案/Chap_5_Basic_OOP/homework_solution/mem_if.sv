///////////////////////////////////////////////////////////////////
// Purpose: Memory interface for Chap_5_Basic_OOP/homework_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: mem_if.sv,v $
// Revision 1.1  2011/05/29 19:03:55  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/20 19:02:27  Greg
// Initial check in
//
///////////////////////////////////////////////////////////////////

interface mem_if (input bit clk);
		bit write;
		bit read;
		bit [7:0] data_in;
		bit [15:0] address;
    	        logic [8:0] data_out;

   clocking cb @(posedge clk);
     output write;
      output read;
      output data_in;
      output address;
      input  data_out;
   endclocking;

   modport slave (input clk, write, read, data_in, address,
              output data_out, import parity);

   modport master (clocking cb, input clk);
   
   
   write_read_assert: assert property(@(posedge clk) (!(write == 1 && read == 1))); 

   function automatic parity(input [7:0] data_in);
      parity = ^mem_bus.data_in;
      // parity = |mem_bus.data_in; // To create errors
   endfunction

 endinterface
