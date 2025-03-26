////////////////////////////////////////////////////////////////////
// Purpose: Class definitions for Chap_6_Randomization/exercise4
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.2  2011/09/06 22:52:36  tumbush.tumbush
// Replaced assert with SV_RAND_CHECK
//
// Revision 1.1  2011/05/29 19:09:57  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/10 18:19:35  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////////////
`default_nettype none
`include "SV_RAND_CHECK.sv"
  program automatic test;
   
   import  my_package::*;
   int write_file;

   initial begin
      Exercise2 MyExercise2; 
      write_file = $fopen("address.dat", "w");
      repeat (1000) begin
	 MyExercise2 = new;
	 `SV_RAND_CHECK(MyExercise2.randomize());
	 MyExercise2.print_address(write_file);
      end
      $fclose(write_file);
   end
   
endprogram

