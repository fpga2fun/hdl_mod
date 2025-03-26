////////////////////////////////////////////////////////////////////
// Purpose: Class definitions for Chap_6_Randomization/exercise10
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: my_package.sv,v $
// Revision 1.4  2011/11/03 01:16:28  tumbush.tumbush
// Add to constraint addr_c additional condition that rw==READ otherwise READ followed by WRITE will not allow the same address.
//
// Revision 1.3  2011/09/06 18:55:42  tumbush.tumbush
// Append _e to typedef not _t
//
// Revision 1.2  2011/09/06 18:54:48  tumbush.tumbush
// Generate 20 transactions.
//
// Revision 1.1  2011/05/29 19:09:53  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.2  2011/05/10 20:07:26  Greg
// Fixed enumerated type rw_t
//
// Revision 1.1  2011/05/10 20:04:07  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////////////
package my_package;

   typedef enum {READ, WRITE} rw_e;
   
class Transaction;
   Transaction old_trans;

   rw_e old_rw;
   bit [1:0] 	old_addr;
   rand rw_e rw;
   rand bit [1:0] addr, data;
   constraint c1 {addr inside{[0:100], [1000:2000]};}
   constraint rw_c{if (old_rw == WRITE) rw != WRITE;}
   constraint addr_c{if ((old_rw == READ) && (rw == READ)) old_addr != addr;}
   
   function void print_all;
      $display("addr = %d, data = %d, rw = %s", addr, data, rw);      
   endfunction //

   function void print_rw;
      $display("rw = %s", rw);      
   endfunction //
   
   function Transaction copy;
      copy = new;
      copy.addr = addr;
      copy.data = data;
   endfunction


   function void post_randomize;
      old_rw = rw;
      old_addr = addr;
   endfunction
   
endclass

endpackage
