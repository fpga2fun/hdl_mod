///////////////////////////////////////////////////////////////////
// Purpose: Package for Chap_6_Randomization/homework_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: my_package.sv,v $
// Revision 1.1  2011/05/29 19:10:04  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/20 19:09:52  Greg
// Initial check in
//
///////////////////////////////////////////////////////////////////
package automatic my_package;
   localparam HADDR_WIDTH = 21;
   typedef enum logic [1:0] {IDLE=2'b00, NONSEQ=2'b10} htrans_t;
   
class Transaction;
   rand bit [HADDR_WIDTH-1:0] HADDR;
   rand bit HWRITE;
   rand bit [7:0] HWDATA;
   rand htrans_t HTRANS;
   rand bit reset;

   constraint HADDR_c {HADDR dist {[0:4]:/40, [5:(2**HADDR_WIDTH)-6]:/20, [(2**HADDR_WIDTH)-5:(2**HADDR_WIDTH)-1]:/40};}
   constraint reset_c {reset dist {0:=90, 1:=10};}

   function void print_trans;
      $display("Transaction is HADDR=%0h, HWRITE=%0b, HWDATA=%0h, HTRANS=%0h, reset=%0b", HADDR, HWRITE, HWDATA, HTRANS, reset);
   endfunction //
   
endclass // Transaction

endpackage
