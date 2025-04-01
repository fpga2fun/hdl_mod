//////////////////////////////////////////////////////////////////////////
// Purpose: SystemVerilog test for Chap_12_Interfacing_with_C/exercise7
// Author: Chris Spear
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.2  2011/09/27 17:21:37  tumbush.tumbush
// Added header information
//
//
//////////////////////////////////////////////////////////////////////////
import "DPI-C" function void mydisplay(inout int h[][]);
program automatic test;
   int a[6:1][8:3]; // Note word ranges are high:low
   initial begin
      foreach (a[i,j]) a[i][j] = i+j;
      mydisplay(a);
      foreach (a[i,j]) $display("V: a[%0d][%0d] = %0d",
				i, j, a[i][j]);
   end
endprogram
