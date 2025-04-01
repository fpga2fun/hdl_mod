////////////////////////////////////////////////////////////////////////////////
// Purpose: Interface for Chap_4_Connecting_the_Testbench_and_Design/exercise4_5
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: reg_if.sv,v $
// Revision 1.2  2011/09/22 01:35:53  tumbush.tumbush
// Replaced dat with data. Added alternate clocking block solution using default.
//
// Revision 1.1  2011/05/28 20:22:57  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/08 22:21:28  Greg
// Initial check-in
//
///////////////////////////////////////////////////////////////////////////////
interface reg_if(input bit clk);
   bit write; bit [15:0] data_in; bit [7:0] address; logic [15:0] data_out;

   /*
   clocking cb @(negedge clk);
      output #25ns write;
      output #25ns address;
      output posedge data_in; 
      input  #15ns data_out;  
   endclocking; // cb
   */
   // or

   clocking cb @(negedge clk);
      default input #15ns output #25ns;
      output write, address;
      output posedge data_in; 
      input  data_out;  
   endclocking; // cb


   modport slave (input clk, write, data_in, output data_out);

   modport master(clocking cb);
   endinterface 
