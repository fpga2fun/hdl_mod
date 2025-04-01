/////////////////////////////////////////////////////////////////
// Purpose: Interface for Chap_10_Advanced_Interfaces/exercise5
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: risc_spm_if.sv,v $
// Revision 1.1  2011/09/16 21:41:14  tumbush.tumbush
// Moved from exercise7
//
//
////////////////////////////////////////////////////////////////
interface risc_spm_if (input bit clk);
   
   bit rst;      // Active low asynchronous reset -  
   bit [7:0] data_out; // Read data from memory unit 
		 
   logic [7:0] address;  // Address to read/write - output
   logic [7:0] data_in;  // Write data to memory unit - output
   logic       write;     // Write flag to memory unit - output

   modport DUT (input clk, data_out, 
                output address, data_in, write);

endinterface
