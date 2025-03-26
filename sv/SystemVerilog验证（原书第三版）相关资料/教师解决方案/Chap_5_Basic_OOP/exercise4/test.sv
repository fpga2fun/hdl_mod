//////////////////////////////////////////////////////////////
// Purpose: Package for Chap_5_Basic_OOP/exercise4
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/29 19:03:46  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/09 13:23:06  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////
`default_nettype none
  program automatic test;
 
   import  my_package::*;

   initial begin
      MemTrans mt1, mt2;
      mt1 = new(.address_init(2));
      mt2 = new(3,4);

      mt1.address = 4'hF;
      mt1.print;
      mt2.print;
      mt2=null;
   end   

endprogram

