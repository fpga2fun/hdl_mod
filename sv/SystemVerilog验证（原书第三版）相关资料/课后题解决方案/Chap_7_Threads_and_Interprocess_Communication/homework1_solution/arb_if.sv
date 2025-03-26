//////////////////////////////////////////////////////////////////////////////////////////////////
// Purpose: Arbiter interface for Chap_7_Threads_and_Interprocess_Communication/homework1_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: arb_if.sv,v $
// Revision 1.1  2011/05/29 19:13:48  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/18 20:10:32  Greg
// Initial checkin
//
//////////////////////////////////////////////////////////////////////////////////////////////////
interface arb_if (input bit clk);
		  bit req;
		  bit en;
		  logic grant;

   clocking cb @(posedge clk);
		  output req;
		  output en;
		  input  grant;
   endclocking;
   

   modport master(clocking cb, output clk);     
      
   endinterface
