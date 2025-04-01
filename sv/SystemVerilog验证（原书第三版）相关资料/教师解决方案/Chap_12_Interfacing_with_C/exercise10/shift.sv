//////////////////////////////////////////////////////////////////////////
// Purpose: SystemVerilog module for Chap_12_Interfacing_with_C/exercise10
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: shift.sv,v $
// Revision 1.1  2011/09/27 19:15:24  tumbush.tumbush
// Initial check-in
//
//
//////////////////////////////////////////////////////////////////////////
module shift;
   import "DPI-C" context function void shift_c();
   export "DPI-C" function shift_sv; // no args or return value
   export "DPI-C" function shift_build; // no args or return value
   export "DPI-C" function shift_print; // no args or return value
   
   // A positive value on n means to left shift i (multiply)
   // A negative value on n means to right shift i (divide)
   // n=0 means to return i

class Shift;

   bit [31:0] shifted;
   
   function void shift_sv(input bit [31:0] i, input int n);
      if (n < 0)
	shifted = (i >> (n *-1));
      else if (n > 0)
	shifted = (i << n);
      else
	shifted = i;
   endfunction // shift_sv

   function void shift_print;
      $display("%0d", shifted);
   endfunction
   
endclass
   
   Shift shiftq[$]; // Queue of Shift objects
   
   // Construct a new memory instance & push on the queue
   function void shift_build();
      Shift s;
      s = new();
      shiftq.push_back(s);
   endfunction

   // idx is the index of the shift handle in shiftq
   function int shift_sv(input int idx, input bit [31:0] i, input int n);
      shiftq[idx].shift_sv(i, n);
   endfunction // shift_sv

   // API to class level shift_print
   function void shift_print(input int idx);
      shiftq[idx].shift_print();
   endfunction // shift_sv

   initial begin
      shift_c();
      $finish;
   end
   

endmodule
