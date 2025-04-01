////////////////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_6_Randomization/homework_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.2  2011/09/06 23:16:16  tumbush.tumbush
// Replaced assert with SV_RAND_CHECK
//
// Revision 1.1  2011/05/29 19:10:04  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/20 19:09:52  Greg
// Initial check in
//
////////////////////////////////////////////////////////////////////
`include "SV_RAND_CHECK.sv"
program automatic test(output logic reset, ahb_if ahb_bus);

   import  my_package::*;

   // # of memory locations to test
   localparam  TESTS = 10;

   // Declare an array of handles to Transaction objects
   Transaction Transaction_array[TESTS*3+2];

initial begin

  // Create TESTS back to back writes
  for (int i=0;i<TESTS;i++) begin
      Transaction_array[i] = new();
     `SV_RAND_CHECK(Transaction_array[i].randomize() with {(HTRANS == NONSEQ); (HWRITE == 1); (reset == 0); (HADDR inside {[0:4]});});
      Transaction_array[i].print_trans;
  end

  // Idle the bus to switch to reads
      Transaction_array[TESTS] = new();
     `SV_RAND_CHECK(Transaction_array[TESTS].randomize() with {(HTRANS == IDLE); (HWRITE == 1); (reset == 0); (HADDR inside {[0:4]});});
      Transaction_array[TESTS].print_trans;
   
  // Create TESTS back to back reads
  for (int i=TESTS+1;i<TESTS*2+1;i++) begin
      Transaction_array[i] = new();
     `SV_RAND_CHECK(Transaction_array[i].randomize() with {(HTRANS == NONSEQ); (HWRITE == 0); (reset == 0); (HADDR inside {[0:4]});});
      Transaction_array[i].print_trans;
  end

     // Idle the bus to switch to random
      Transaction_array[TESTS*2+1] = new();
     `SV_RAND_CHECK(Transaction_array[TESTS*2+1].randomize() with {(HTRANS == IDLE); (HWRITE == 1); (reset == 0); (HADDR inside {[0:4]});});
      Transaction_array[TESTS*2+1].print_trans;

 
   // Create TESTS new objects and store the
   // handles to the objects in the Transaction_array
   for (int i=TESTS*2+2;i<TESTS*3+2;i++) begin
      Transaction_array[i] = new();
      `SV_RAND_CHECK(Transaction_array[i].randomize());
      Transaction_array[i].print_trans;
   end   
   
   // At the positive edge of each clock, send out transaction i.
   // If the previous transaction was a write HWDATA = transaction[i-1].HWDATA
      for (int i=0;i<TESTS*3+2;i++) begin
	 @(posedge ahb_bus.HCLK);
	 ahb_bus.HADDR <= Transaction_array[i].HADDR;
         ahb_bus.HWRITE <= Transaction_array[i].HWRITE;
	 ahb_bus.HTRANS <= Transaction_array[i].HTRANS;
	 if (i != 0) begin
           if ((Transaction_array[i-1].HTRANS == NONSEQ) && Transaction_array[i-1].HWRITE)	 
              ahb_bus.HWDATA <= Transaction_array[i-1].HWDATA;
	 end
	 reset <= Transaction_array[i].reset;
      end
      $finish;
   end // initial begin

   
endprogram
