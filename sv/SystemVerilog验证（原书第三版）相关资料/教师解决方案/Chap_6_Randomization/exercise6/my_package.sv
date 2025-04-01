////////////////////////////////////////////////////////////////////
// Purpose: Class definitions for Chap_6_Randomization/exercise6
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: my_package.sv,v $
// Revision 1.2  2011/09/08 17:23:10  tumbush.tumbush
// Remove $ from inside constraint.
//
// Revision 1.1  2011/05/29 19:10:00  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/10 19:08:09  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////////////
package my_package;
   
class MemTrans;
   rand bit x;
   rand bit [1:0] y;
   constraint c_xy {
      y inside{[x:3]};
      solve x before y;
   }
   function void print_all;
      $display("x = %0d, y = %0d", x, y);
   endfunction
endclass   

endpackage
