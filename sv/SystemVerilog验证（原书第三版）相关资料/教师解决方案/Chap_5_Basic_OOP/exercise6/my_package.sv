//////////////////////////////////////////////////////////////
// Purpose: Package for Chap_5_Basic_OOP/exercise6
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: my_package.sv,v $
// Revision 1.2  2011/09/28 17:36:41  tumbush.tumbush
// don't need to specify the class in the constructor when assigning to last_address.
//
// Revision 1.1  2011/05/29 19:03:49  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/09 13:31:18  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////
package my_package;
class MemTrans;	
   logic [7:0] data_in;
   logic [3:0] address;
   static logic [3:0] last_address;
   
   function void print;
      $display("Data_in = 0x%0h, address = 0x%0h", data_in, address);
   endfunction //

   static function void print_last_address;
      $display("last_address is 0x%0h",  last_address);
   endfunction 

   
   function new(logic [7:0] data_init = 0,  logic [3:0] address_init = 0);
      data_in = data_init;
      address = address_init;
      last_address = address;
   endfunction
endclass


endpackage
