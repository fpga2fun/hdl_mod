/////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_5_Basic_OOP/exercise3
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.2  2011/09/01 21:18:26  tumbush.tumbush
// Initialize 2nd object by name as well, not by position.
//
// Revision 1.1  2011/05/29 19:03:45  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/09 13:17:19  Greg
// Initial check-in
//
////////////////////////////////////////////////////////
`default_nettype none
  program automatic test;
 
   import  my_package::*;

   initial begin
      MemTrans mt1, mt2;
      mt1 = new(.address_init(2));
      mt2 = new(.data_init(3), .address_init(4));
      mt1.print;
      mt2.print;
   end   

endprogram

