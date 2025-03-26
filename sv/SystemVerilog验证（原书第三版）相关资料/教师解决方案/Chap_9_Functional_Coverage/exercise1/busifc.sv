////////////////////////////////////////////////////////////////
// Purpose: Interface for Chap_9_Functional_Coverage/exercise1
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: busifc.sv,v $
// Revision 1.1  2011/05/29 19:24:34  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/12 15:16:27  Greg
// Initial check-in
//
////////////////////////////////////////////////////////////////
interface busifc(input bit clk);
   bit [31:0] data;
   bit [ 2:0] port; // Eight port numbers

   clocking cb @(posedge clk);
      output  data;
      output  port;
   endclocking // cb

   modport TB(clocking cb);

   endinterface


     
