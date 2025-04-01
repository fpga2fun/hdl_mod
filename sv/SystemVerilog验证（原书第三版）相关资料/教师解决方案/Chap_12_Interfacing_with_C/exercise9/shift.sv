//////////////////////////////////////////////////////////////////////////
// Purpose: SystemVerilog module for Chap_12_Interfacing_with_C/exercise9
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: shift.sv,v $
// Revision 1.3  2011/09/27 19:20:29  tumbush.tumbush
// Initial check-in
//
//
//////////////////////////////////////////////////////////////////////////
module shift;
   import "DPI-C" context function void shift_c();
   export "DPI-C" function shift_sv; // no args or return value
   export "DPI-C" function shift_build; // no args or return value
   
   // A positive value on n means to left shift i (multiply)
   // A negative value on n means to right shift i (divide)
   // n=0 means to return i

class Shift;
   function int shift_sv(input bit [31:0] i, input int n);
      if (n < 0)
	shift_sv = (i >> (n *-1));
      else if (n > 0)
	shift_sv = (i << n);
      else
	shift_sv = i;
   endfunction // shift_sv
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
      shift_sv = shiftq[idx].shift_sv(i, n);
   endfunction // shift_sv

   initial begin
      shift_c();
      $finish;
   end
   

endmodule
