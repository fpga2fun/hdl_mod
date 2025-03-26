////////////////////////////////////////////////////////////////////
// Purpose: Class definitions for Chap_6_Randomization/exercise8
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: my_package.sv,v $
// Revision 1.3  2011/10/13 19:10:11  tumbush.tumbush
// Added alternate solution using sum()
//
// Revision 1.2  2011/09/06 18:39:15  tumbush.tumbush
// Print out array line by line. Declare array correctly.
//
// Revision 1.1  2011/05/29 19:10:02  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/10 19:47:56  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////////////
`default_nettype none
  package my_package;

   parameter int HEIGHT = 10;
   parameter int WIDTH  = 10;
   parameter int PERCENT_WHITE = 20;
   typedef enum bit {BLACK, WHITE} colors_t;
class Screen;
   rand colors_t pixels [HEIGHT][WIDTH];
   constraint colors_c {foreach (pixels[i,j]) pixels[i][j] dist {BLACK :=100-PERCENT_WHITE, WHITE :=  PERCENT_WHITE};}
   // or
   // constraint colors_c {(pixels.sum() with (item.sum() with (int'(item))) == PERCENT_WHITE);}

   function void print_screen;
      int 	 count = 0;
      foreach (pixels[i])
        $display("%p", pixels[i]);
      foreach (pixels[i,j])
	count += pixels[i][j];
      $display("Num of pixels=WHITE = %0d", count);
   endfunction //

endclass // Screen


endpackage
