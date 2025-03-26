////////////////////////////////////////////////////////////////////////////////////////
// Purpose: Testbench for Chap_10_Advanced_Interfaces/homework_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: top.sv,v $
// Revision 1.2  2011/09/17 20:56:38  tumbush.tumbush
// Declare mailbox size/type instead of using a typedef. Declare mailbox argument to new as input
//
// Revision 1.1  2011/05/27 02:58:59  tumbush.tumbush
// Checked into cloud.
//
// Revision 1.1  2011/04/05 22:24:10  Greg
// Initial check-in
//
////////////////////////////////////////////////////////////////////////////////////////
`default_nettype none
`include "risc_spm_if.sv"
  module top;

   bit clk;

   parameter ADDRESS_WIDTH = 7;

   // Instantiate the risc_spm interface
   risc_spm_if #(.ADDRESS_WIDTH(ADDRESS_WIDTH)) risc_bus(clk);
   
   // Instantiate the testbench using an XMR
   test  #(.ADDRESS_WIDTH(ADDRESS_WIDTH)) test();   

   // Instantite the DUT
   RISC_SPM RISC_SPM (
		      .clk(risc_bus.clk),      // input
                      .rst(risc_bus.rst),      // Active low asynchronous reset -  input
                      .data_out(risc_bus.data_out), // Read data from memory unit - input
      
		      .address(risc_bus.address),  // Address to read/write - output
		      .data_in(risc_bus.data_in),  // Write data to memory unit - output
		      .write(risc_bus.write)     // Write flag to memory unit - output
		      );

   // clocking
   always #50ns clk = !clk;
   
endmodule

