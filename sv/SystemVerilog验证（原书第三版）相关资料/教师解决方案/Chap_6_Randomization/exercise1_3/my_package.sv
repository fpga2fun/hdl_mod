////////////////////////////////////////////////////////////////////
// Purpose: Class definitions for Chap_6_Randomization/exercise1_3
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: my_package.sv,v $
// Revision 1.2  2011/09/06 18:16:12  tumbush.tumbush
// Change type of data and address to bit from logic.
//
// Revision 1.1  2011/05/29 19:09:55  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.3  2011/05/10 16:30:17  Greg
// Fixed typo in print_all function
//
// Revision 1.2  2011/05/10 16:25:08  Greg
// Replaced MemTrans with Exercise1. Replaced data_in with data
//
// Revision 1.1  2011/05/10 16:20:24  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////////////
package my_package;
class Exercise1;	
   rand bit [7:0] data;
   rand bit [3:0] address;
   constraint address_c {
      //address > 2; 
      //address < 5;
      // or
      //((address==3) || (address==4));
      // or
      address inside {[3:4]};
   }

   function void print_all;
      $display("data = 0d%0d, address = 0d%0d", data, address);
   endfunction
   
endclass // Exercise1

endpackage
