////////////////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_6_Randomization/exercise8
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.2  2011/09/06 23:09:28  tumbush.tumbush
// Replaced assert with SV_RAND_CHECK
//
// Revision 1.1  2011/05/29 19:10:02  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/10 19:47:56  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////////////
`default_nettype none
`include "SV_RAND_CHECK.sv"
program automatic monitor;
   import my_package::*;

   Screen screen;

   initial begin
      screen = new();
      `SV_RAND_CHECK(screen.randomize());
      screen.print_screen;
   end

endprogram : monitor
