////////////////////////////////////////////////////////////////////
// Purpose: Class definitions for Chap_6_Randomization/exercise4
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: my_package.sv,v $
// Revision 1.2  2011/09/06 18:22:42  tumbush.tumbush
// Change type of data and address to bit from logic.
//
// Revision 1.1  2011/05/29 19:09:57  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/10 18:19:35  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////////////
package my_package;
   
class Exercise2;	
   rand bit [7:0] data;
   rand bit [3:0] address;
   constraint data_c{data == 5;}
   constraint address_dist {
      address dist{0:=10, [1:14]:/80, 15:=10};
   } 
   

   function void print_address(int write_file);
      $fdisplay(write_file, "%0d", address);
   endfunction //
   
   
endclass // Exercise2
   

endpackage
