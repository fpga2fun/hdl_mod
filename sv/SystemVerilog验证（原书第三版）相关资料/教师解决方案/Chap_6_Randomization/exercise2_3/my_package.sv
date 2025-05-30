////////////////////////////////////////////////////////////////////
// Purpose: Class definitions for Chap_6_Randomization/exercise2_3
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: my_package.sv,v $
// Revision 1.2  2011/09/06 18:18:37  tumbush.tumbush
// Changed type of data and address to type bit from logic.
//
// Revision 1.1  2011/05/29 19:09:56  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/10 16:31:48  Greg
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
   

   function void print_all;
      $display("data = %d, address = %d", data, address);
   endfunction
   
endclass // Exercise2
   

endpackage
