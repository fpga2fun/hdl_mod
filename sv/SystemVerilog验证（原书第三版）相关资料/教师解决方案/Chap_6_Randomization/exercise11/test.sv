////////////////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_6_Randomization/exercise11
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.3  2011/09/06 23:14:15  tumbush.tumbush
// Replaced assert with SV_RAND_CHECK
//
// Revision 1.2  2011/09/06 19:00:16  tumbush.tumbush
// Generate 20 transactions. Declare enumerated types with _e, not _t.
//
// Revision 1.1  2011/05/29 19:09:54  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/10 20:10:55  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////////////
`default_nettype none
`include "SV_RAND_CHECK.sv"
  program automatic test;
   
   import  my_package::*;
   RandTransaction rt;
   
initial begin
   rt=new();
   `SV_RAND_CHECK(rt.randomize());
   rt.print_all;
end

endprogram

