//////////////////////////////////////////////////////////////
// Purpose: Package for Chap_5_Basic_OOP/exercise2
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: my_package.sv,v $
// Revision 1.1  2011/05/29 19:03:44  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/09 13:10:18  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////
package my_package;
class MemTrans;	
   logic [7:0] data_in;
   logic [3:0] address;
   function void print;
      $display("Data_in = 0x%0h, address = 0x%0h", data_in, address);
   endfunction
   function new;
      data_in = 8'h0;
      address = 4'h0;
   endfunction
endclass

endpackage
