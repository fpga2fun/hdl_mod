////////////////////////////////////////////////////////////////////
// Purpose: Class definitions for Chap_6_Randomization/exercise11
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: my_package.sv,v $
// Revision 1.2  2011/09/06 19:00:16  tumbush.tumbush
// Generate 20 transactions. Declare enumerated types with _e, not _t.
//
// Revision 1.1  2011/05/29 19:09:54  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/10 20:10:55  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////////////
package my_package;

   typedef enum {READ, WRITE} rw_e; 
   localparam TESTS = 20;

class Transaction;
   rand rw_e rw;
   rand bit [1:0] addr, data;
endclass
   
class RandTransaction;
   rand Transaction trans_array[];

   constraint  rw_c {foreach (trans_array[i])
                        if ((i>0) && (trans_array[i-1].rw == WRITE)) trans_array[i].rw != WRITE;}
   
   constraint  addr_c {foreach (trans_array[i])
                        if ((i>0) && (trans_array[i-1].rw == READ)) trans_array[i-1].addr != trans_array[i].addr;}

      function new();
	 trans_array = new[TESTS]; 
	 foreach (trans_array[i])
	   trans_array[i] = new();
      endfunction;

      function void print_rw;
	 foreach (trans_array[i])
	   $display("trans_array[%0d].rw = %s", i, trans_array[i].rw);      
      endfunction //

   function void print_all;
      foreach (trans_array[i])
         $display("addr = %d, data = %d, rw = %s", trans_array[i].addr, trans_array[i].data, trans_array[i].rw);      
   endfunction //

      
   endclass

endpackage
