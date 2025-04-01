///////////////////////////////////////////////////////////
// Purpose: Stimulus for Chap_5_Basic_OOP/homework_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/29 19:03:55  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/20 19:02:27  Greg
// Initial check in
//
///////////////////////////////////////////////////////////

program automatic test(mem_if mem_bus);

   import  my_package::*;
   
   int index;
   bit begin_read = 0;

   // # of memory locations to test
   localparam  TESTS = 6;

// Declare an array of handles to Transaction objects
   Transaction Transaction_array[TESTS];

initial begin
   $timeformat(-9, 0, "ns", 0);
   mem_bus.cb.write <= 0;
   mem_bus.cb.read <= 0;
   
   // Create TESTS new objects and store the
   // handles to the objects in the Transaction_array
   for (int i=0;i<TESTS;i++) begin
      Transaction_array[i] = new();
   end
      
   // ------ Do the test -------
   // Do the writes
   index = 0;
   do begin
      @mem_bus.cb;
      mem_bus.cb.write <= 1;
      mem_bus.cb.data_in <=  Transaction_array[index].data_in;
      mem_bus.cb.address <= Transaction_array[index].address;
      index++;
   end
   while (index != TESTS);

   @mem_bus.cb;
   mem_bus.cb.write <= 0;
   
   // Shuffle the array
   Transaction_array.shuffle;

   // Do the reads
   begin_read = 1;
   for (int i=0;i<TESTS;i++) begin
      mem_bus.cb.read <= 1;
      mem_bus.cb.address <= Transaction_array[i].address;
      @mem_bus.cb; // read is complete
   end

   @mem_bus.cb;
   mem_bus.cb.read <= 0;

   // Check the read=1 and write=1 checker
   mem_bus.cb.read <= 1;
   mem_bus.cb.write <= 1;
   @(mem_bus.cb);
   mem_bus.cb.read <= 0;
   mem_bus.cb.write <= 0;
   @(mem_bus.cb);

   Transaction::print_error;   
   
end // initial begin

// Check the result of the reads
initial begin
   @(begin_read);
   @mem_bus.cb;
   for (int i=0;i<TESTS;i++) begin
      @mem_bus.cb;
      Transaction_array[i].data_out = mem_bus.cb.data_out;
      Transaction_array[i].Check9Bits;
      Transaction_array[i].print_data_out;
   end
end

endprogram
