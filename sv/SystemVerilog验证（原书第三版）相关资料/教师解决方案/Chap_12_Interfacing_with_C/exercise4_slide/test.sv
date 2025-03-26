//////////////////////////////////////////////////////////////////////
// Purpose: Test module for Chap_12_Interfacing_with_C/exercise4_slide
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/09/27 19:43:57  tumbush.tumbush
// Initial check-in
//
//
//////////////////////////////////////////////////////////////////////
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
