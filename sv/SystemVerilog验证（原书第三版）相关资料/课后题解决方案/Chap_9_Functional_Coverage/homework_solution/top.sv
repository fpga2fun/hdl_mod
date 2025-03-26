////////////////////////////////////////////////////////////////////////////////////////
// Purpose: Testbench for Chap_9_Functional_Coverage/homework_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: top.sv,v $
// Revision 1.1  2011/05/29 19:24:40  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/04/02 21:36:36  Greg
// Initial check-in
//
////////////////////////////////////////////////////////////////////////////////////////
`default_nettype none
`include "risc_spm_if.sv"
  module top;

   bit clk;

   // Instantiate the risc_spm interface
   risc_spm_if risc_bus(clk);
   
   // Instantiate the testbench
   test test(risc_bus);   

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

