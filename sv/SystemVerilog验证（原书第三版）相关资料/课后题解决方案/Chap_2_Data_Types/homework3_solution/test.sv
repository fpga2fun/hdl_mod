//////////////////////////////////////////////////////////////
// Purpose: Testbench for Chap_2_Data_Types/homework3_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/28 19:48:17  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/17 15:56:34  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////

`default_nettype none
  module test;
   
   bit clk;
   bit reset;
   bit write;
   bit [15:0] data_in;
   bit [2:0]  address;
   logic [15:0] data_out;

   // Create an associative array to hold the reset values
   bit [15:0] 	reset_assoc[string];

   typedef enum {
   ADC0_REG,
   ADC1_REG,
   TEMP_SENSOR0_REG,
   TEMP_SENSOR1_REG,
   ANALOG_TEST,
   DIGITAL_TEST,
   AMP_GAIN,
   DIGITAL_CONFIG
} reg_t;

   reg_t my_reg;
   int error = 0, correct = 0;
   
initial begin
   // Fill the associative array with the expected reset values
   reset_assoc["ADC0_REG"] = 16'hFFFF;
   reset_assoc["ADC1_REG"] = 16'h0;
   reset_assoc["TEMP_SENSOR0_REG"] = 16'h0;
   reset_assoc["TEMP_SENSOR1_REG"] = 16'h0;
   reset_assoc["ANALOG_TEST"] = 16'hABCD;
   reset_assoc["DIGITAL_TEST"] = 16'h0;
   reset_assoc["AMP_GAIN"] = 16'h0;
   reset_assoc["DIGITAL_CONFIG"] = 16'h1;

      // Create a reset
      reset = 0;
      @(negedge clk);
      reset = 1;
      repeat(3) @(negedge clk);
      reset = 0;

   @(negedge clk);
   
   // Check all the reset values
   $display("%0t: Checking reset values", $time);
   for (int i=0;i<my_reg.last+1;i++) begin
      address = my_reg;
      @(negedge clk);
      Check16Bits(my_reg.name, reset_assoc[my_reg.name], data_out);
      my_reg = my_reg.next;
   end

   @(negedge clk);

   // Write FFFF to every register
   $display("%0t: Writing 16'hFFFF to every register", $time);
   for (int i=0;i<my_reg.last+1;i++) begin
      address = my_reg;
      data_in = 16'hFFFF;
      write = 1;
      @(negedge clk);
      my_reg = my_reg.next;
   end

   @(negedge clk);
   write = 0;

   // Read every register, expecting FFFF
   // Check all the reset values
   $display("%0t: Reading 16'hFFFF from every register", $time);
   for (int i=0;i<my_reg.last+1;i++) begin
      address = my_reg;
      @(negedge clk);
      Check16Bits(my_reg.name, 16'hFFFF, data_out);
      my_reg = my_reg.next;
   end

   // Reset and check reset values again.
      reset = 0;
      @(negedge clk);
      reset = 1;
      repeat(3) @(negedge clk);
      reset = 0;

   @(negedge clk)
   
   // Check all the reset values
   $display("%0t: Checking reset values", $time);
   for (int i=0;i<my_reg.last+1;i++) begin
      address = my_reg;
      @(negedge clk);
      Check16Bits(my_reg.name, reset_assoc[my_reg.name], data_out);
      my_reg = my_reg.next;
   end

   @(negedge clk);

   // Write and read a walking 1's pattern to each register
   $display("%0t: Writing/reading walking 1's to every register", $time);
   for (int i=0;i<my_reg.last+1;i++) begin
      for (int j=0;j<16;j++) begin
	 // do the write
	 address = my_reg;
	 data_in = 0;
	 data_in[i]=1;
	 write = 1;
	 // Do the read
	 @(negedge clk);
	 write = 0;
	 Check16Bits(my_reg.name, data_in, data_out);
	 my_reg = my_reg.next;
	 @(negedge clk);
      end // Walking 1's
   end // All regs

   $display("%0t: At end of test error = %0d and correct = %0d", $time, error, correct);   

   $finish;
   
end // initial begin

   // Instantiate config_reg
  config_reg config_reg(
		.clk(clk),
		.reset(reset),
		.write(write),
		.data_in(data_in),
		.address(address),
		.data_out(data_out)
);
   
   // Create a clock
   initial begin
      clk = 1'b0;
      forever #50ns clk=!clk;
   end

   task Check16Bits(input string checked, input bit [15:0] expected, input logic [15:0] actual);
      if (expected !== actual) begin
	 $display("%0t: Read from register %s expected 0x%0h but got 0x%0h", $time, checked, expected, actual);
	 error++;
      end
      else
	correct++;
   endtask // Check9Bits
   

endmodule // test

