///////////////////////////////////////////////////////////////////////////////////////////////////
// Purpose: RISC_SPM interface for Chap_9_Functional_Coverage/homework_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: risc_spm_if.sv,v $
// Revision 1.1  2011/05/29 19:24:40  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/04/02 21:36:36  Greg
// Initial check-in
//
////////////////////////////////////////////////////////////////////////////////////////////////////
interface risc_spm_if (input bit clk);
   
   bit rst;      // Active low asynchronous reset -  
   bit [7:0] data_out; // Read data from memory unit 
		 
   logic [7:0] address;  // Address to read/write - output
   logic [7:0] data_in;  // Write data to memory unit - output
   logic       write;     // Write flag to memory unit - output

   modport DUT (input clk, data_out, 
                output address, data_in, write);

endinterface
