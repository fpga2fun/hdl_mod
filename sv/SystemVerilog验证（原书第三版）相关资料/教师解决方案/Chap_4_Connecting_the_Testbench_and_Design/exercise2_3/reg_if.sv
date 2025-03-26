////////////////////////////////////////////////////////////////////////////////
// Purpose: Interface for Chap_4_Connecting_the_Testbench_and_Design/exercise2_3
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: reg_if.sv,v $
// Revision 1.2  2011/09/29 20:50:38  tumbush.tumbush
// Changed dat_* to data_*
//
// Revision 1.1  2011/05/28 20:22:56  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/08 22:18:18  Greg
// Initial check-in
//
///////////////////////////////////////////////////////////////////////////////
interface reg_if(input bit clk);
   bit write; bit [15:0] data_in; bit [7:0] address; logic [15:0] data_out;

   clocking cb @(negedge clk);
      output  write, address, data_in; 
      input  data_out;  
   endclocking;

   modport slave (input clk, write, data_in, output data_out);

   modport master(clocking cb);
   endinterface 
