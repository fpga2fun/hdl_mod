////////////////////////////////////////////////////////////////////////////////////
// Purpose: DUT interface for Chap_7_Threads_and_Interprocess_Communicaton/problem7
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: my_if.sv,v $
// Revision 1.1  2011/05/29 19:13:47  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/10 23:26:07  Greg
// Initial check-in
//
// Revision 1.1  2011/03/19 20:27:02  Greg
// Initial check-in
//
////////////////////////////////////////////////////////////////////////////////////

interface my_if (input bit clk);
   bit out1;
   bit out2;

   // Direction from the testbench perspective
   clocking cb @(posedge clk);
      input out1, out2;
   endclocking // cb
 
   modport dut (output out1, out2, input clk);

   modport test(clocking cb);

   
endinterface
 