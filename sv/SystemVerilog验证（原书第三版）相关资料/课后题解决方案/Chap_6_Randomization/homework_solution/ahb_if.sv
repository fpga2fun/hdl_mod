/////////////////////////////////////////////////////////////////////////
// Purpose: AHB Interface for Chap_6_Randomization/homework_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: ahb_if.sv,v $
// Revision 1.1  2011/05/29 19:10:04  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/20 19:09:52  Greg
// Initial check in
//
/////////////////////////////////////////////////////////////////////////
interface ahb_if (input bit HCLK);
   bit [20:0] HADDR;
   bit 	      HWRITE;
   bit [7:0]  HWDATA;
   bit [1:0]  HTRANS;
   logic [7:0] HRDATA;
      
   modport slave (input HCLK, HADDR, HWRITE, HWDATA, HTRANS, output HRDATA);

   modport master (output HCLK, HADDR, HWRITE, HWDATA, HTRANS, input HRDATA);
   
 endinterface
