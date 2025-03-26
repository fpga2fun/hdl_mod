/////////////////////////////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_8_Advanced_OOP_and_Testbench_Guidelines/exercise5
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.2  2011/09/13 15:11:59  tumbush.tumbush
// Updated as per July 21, 2011 version of Chapter 8.
//
// Revision 1.1  2011/05/29 19:16:06  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/11 22:40:05  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////////////////////////
`default_nettype none
  program automatic test;

   import my_package::*;

   ExtBinary mc, mc2;
   Binary b;
   
   initial begin


      // a)-------------------------------
      /*
       mc = new(15, 8);
       b = mc;
       */ 
      // Result: // base handle b points to extended object. Handle mc2 points to null
      
      // b)-----------------------------
      /*
      b = new(15, 8);
      mc = b;
      */
      // Result: Compile error: types are not assignment compatible

      // c)----------------------------
      /*
      mc = new(15, 8);
      b = mc;
      mc2 = b;
       */
      // Result: Compile error: types are not assignment compatible

      // d)---------------------------
      mc = new(15, 8);
      b = mc;
      if($cast(mc2, b))
	$display("Success");
      else
	$display("ERROR: cannot assign");
      // Result: Handle b and mc2 will point to object mc. The string Success will print.
          
   end

endprogram
