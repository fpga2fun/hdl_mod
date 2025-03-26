/////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_5_Basic_OOP/exercise2
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/29 19:03:44  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/09 13:10:18  Greg
// Initial check-in
//
////////////////////////////////////////////////////////
`default_nettype none
  program automatic test;
 
   import  my_package::*;


   initial begin
      MemTrans MyMemTrans;
      MyMemTrans = new();
      MyMemTrans.print;   
   end
   

endprogram

