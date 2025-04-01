//////////////////////////////////////////////////////////////
// Purpose: Package for Chap_5_Basic_OOP/exercise7
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: my_package.sv,v $
// Revision 1.2  2011/07/21 23:32:15  tumbush.tumbush
// Replaced PrintBase with PrintUtilities. Converted with dos2unix.
//
// Revision 1.1  2011/05/09 13:35:23  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////
package my_package;

class PrintUtilities;
   function void print_4(input string name, input [3:0] val_4bits);
      $display("%0t: %s = 0x%0h", $time, name, val_4bits);
   endfunction // print_data_address

   function void print_8(input string name, input [7:0] val_8bits);
      $display("%0t: %s = 0x%0h", $time, name, val_8bits);
   endfunction // print_8
endclass // PrintUtilities      

class MemTrans;	
   bit [7:0] data_in;
   bit [3:0] address;
   
   PrintUtilities print;

   
   function new();
      print = new();
   endfunction // new
   
   function void print_all;
      print.print_8("data_in", data_in);
      print.print_4("address", address);
   endfunction // print_data_address

endclass

endpackage
