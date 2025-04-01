/////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_5_Basic_OOP/exercise9
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.2  2011/09/02 19:40:20  tumbush.tumbush
// Include Statistics object so that deep copy is required.
//
// Revision 1.1  2011/05/29 19:03:52  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/09 13:43:34  Greg
// Initial check-in
//
////////////////////////////////////////////////////////
`default_nettype none
  program automatic test;
 
   import  my_package::*;

   initial begin
      MemTrans mt1, mt2, mt3;
      mt1 = new();
      mt2 = new mt1;
      mt3 = mt1.copy();


      // Demonstrate that changing startT for mt1 changes mt2 because both
      // point to the same stats object.
      // Changing startT for mt1 does not change mt3 because they
      // point to different stats object.
      mt1.stats.print_start();
      mt2.stats.print_start();
      mt3.stats.print_start();
      
      mt1.stats.startT = 100;

      mt1.stats.print_start();
      mt2.stats.print_start();
      mt3.stats.print_start();
           
      
   end   
   endprogram



