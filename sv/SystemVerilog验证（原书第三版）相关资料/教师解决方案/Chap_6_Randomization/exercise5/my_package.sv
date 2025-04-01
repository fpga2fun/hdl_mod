////////////////////////////////////////////////////////////////////
// Purpose: Class definitions for Chap_6_Randomization/exercise5
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: my_package.sv,v $
// Revision 1.1  2011/05/29 19:09:59  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/10 18:55:32  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////////////
package my_package;
class Stim;
   const bit [31:0] CONGEST_ADDR = 42;
   typedef  enum    {READ, WRITE, CONTROL} stim_e;
   randc stim_e kind;
   rand bit [31:0] len, src, dst;
   bit 		    congestion_test;
   constraint c_stim {
      len < 1000;
      len > 0;
      if (congestion_test) {
        dst inside {[CONGEST_ADDR-10:CONGEST_ADDR+10]};
        src == CONGEST_ADDR;
   }
      else
        src inside {0, [2:10], [100:107]};
   }

   function void print_all;
      $display("len = 0d%0d, src = 0d%0d, dst = 0d%0d", len, src, dst);
   endfunction //
   
endclass

endpackage
