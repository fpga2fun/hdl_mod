////////////////////////////////////////////////////////////////////
// Purpose: Class definitions for Chap_6_Randomization/exercise7
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: my_package.sv,v $
// Revision 1.2  2011/09/06 18:29:27  tumbush.tumbush
// Changed type of rw, data_in, and address to bit from logic.
//
// Revision 1.1  2011/05/29 19:10:01  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/10 19:19:49  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////////////
package my_package;
   
class MemTrans;	
   rand bit rw; // read if rw = 0, write if rw = 1
   rand bit [7:0] data_in;
   rand bit [3:0] address;
   constraint valid_rw_address {(rw == 0)->(address inside {[0:7]});}
   
   function void print_all;
      $display("rw = %b, data_in = %d, address = %d", rw, data_in, address);
   endfunction
   
endclass // MemTrans

endpackage
