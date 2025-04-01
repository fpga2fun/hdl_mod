/////////////////////////////////////////////////////////////////////////////////
// Purpose: AHB interface for Chap_4_Connecting_the_Testbench_and_Design/exercise1
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: ahb_if.sv,v $
// Revision 1.1  2011/05/28 20:22:55  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/08 22:13:59  Greg
// Initial check-in
//
////////////////////////////////////////////////////////////////////////////////

interface ahb_if;
   bit         HCLK;
   bit [20:0]  HADDR;
   bit 	       HWRITE;
   bit [1:0]   HTRANS;
   bit [7:0]   HWDATA;
   logic [7:0] HRDATA;

   localparam 	IDLE = 2'b00,
                NONSEQ = 2'b10;
   
   // At the negative edge of the clock ensure HTRANS is either IDLE or NONSEQ
   always @(negedge HCLK) begin
      if ((HTRANS != IDLE) && (HTRANS != NONSEQ))
	$display("Error: HTRANS = 2'b%0b", HTRANS);
   end

   modport slave(input HCLK, HADDR, HWRITE, HTRANS, HWDATA, output HRDATA);
   
endinterface
