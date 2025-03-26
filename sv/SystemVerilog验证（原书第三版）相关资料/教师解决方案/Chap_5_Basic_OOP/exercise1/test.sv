/////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_5_Basic_OOP/exercise1
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/29 19:03:43  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/09 13:05:46  Greg
// Initial check-in
//
////////////////////////////////////////////////////////
`default_nettype none
  program automatic test;
 
   import  my_package::*;

   initial begin
      MemTrans MyMemTrans;
      MyMemTrans = new();
      // or
      // MemTrans MyMemTrans = new();
      
      MyMemTrans.print;
   end
   

endprogram

