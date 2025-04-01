/////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_5_Basic_OOP/exercise7
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.2  2011/07/21 23:32:15  tumbush.tumbush
// Replaced PrintBase with PrintUtilities. Converted with dos2unix.
//
// Revision 1.1  2011/05/09 13:35:23  Greg
// Initial check-in
//
////////////////////////////////////////////////////////
`default_nettype none
  program automatic test;
 
   import  my_package::*;


   initial begin
      MemTrans mt1, mt2;
      
      mt1 = new();
      mt2 = new();

      mt1.address = 4'h5;
      mt2.data_in = 8'hA3;
      
      mt1.print_all;
      // or 
      mt2.print_all;
      mt1.print.print_8("data_in", mt1.data_in); // Not asked for
   end

endprogram

