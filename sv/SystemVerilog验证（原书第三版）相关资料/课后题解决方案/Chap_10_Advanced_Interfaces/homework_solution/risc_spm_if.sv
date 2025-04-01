///////////////////////////////////////////////////////////////////////////////////////////////////
// Purpose: RISC_SPM interface for Chap_10_Advanced_Interfaces/homework_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: risc_spm_if.sv,v $
// Revision 1.2  2011/09/17 20:56:38  tumbush.tumbush
// Declare mailbox size/type instead of using a typedef. Declare mailbox argument to new as input
//
// Revision 1.1  2011/05/27 02:58:59  tumbush.tumbush
// Checked into cloud.
//
// Revision 1.1  2011/04/05 22:24:10  Greg
// Initial check-in
//
////////////////////////////////////////////////////////////////////////////////////////////////////
interface risc_spm_if #(ADDRESS_WIDTH=8) (input bit clk);
   
   bit rst;      // Active low asynchronous reset -  
   bit [7:0] data_out; // Read data from memory unit 
		 
   logic [ADDRESS_WIDTH-1:0] address;  // Address to read/write - output
   logic [7:0] data_in;  // Write data to memory unit - output
   logic       write;     // Write flag to memory unit - output

   modport DUT (input clk, data_out, 
                output address, data_in, write);

endinterface
