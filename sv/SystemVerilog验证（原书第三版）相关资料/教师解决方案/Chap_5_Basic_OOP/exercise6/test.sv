/////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_5_Basic_OOP/exercise6
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/29 19:03:49  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/09 13:31:18  Greg
// Initial check-in
//
////////////////////////////////////////////////////////
`default_nettype none
  program automatic test;
 
   import  my_package::*;


   initial begin
      MemTrans mt1, mt2;
      mt1 = new(.address_init(2));
      mt2 = new(3,4);
      mt1.address = 4'hf;
      mt1.print;
      mt2.print;
      MemTrans::print_last_address;
      mt1.print_last_address;
      mt2.print_last_address;
      mt2 = null;
   end
   

endprogram

