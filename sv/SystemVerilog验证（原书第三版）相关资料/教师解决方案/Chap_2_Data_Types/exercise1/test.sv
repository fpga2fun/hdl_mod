////////////////////////////////////////////////////////////////////////////////
// Purpose: SystemVerilog code for Chap_2_Data_Types/exercise1
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: test.sv,v $
// Revision 1.1  2011/05/28 19:48:04  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.2  2011/05/03 22:45:02  Greg
// Updated header
//
////////////////////////////////////////////////////////////////////////////////

module test;

   byte my_byte;
   integer my_integer;
   int my_int;
   bit [15:0] my_bit;
   shortint my_short_int1;
   shortint my_short_int2;

   initial begin
      my_integer = 32'b000_1111_xxxx_zzzz;
      my_int = my_integer;
      my_bit = 16'h8000;
      my_short_int1= my_bit;
      my_short_int2 = my_short_int1-1;

      // a) What is the range of values my_byte can take?
      my_byte = 8'h80;
      $display("my_byte = 8'h80 (i.e. max neg) = 0d%0d", my_byte);
      my_byte = 8'h7F;
      $display("my_byte = 8'h7F (i.e. max pos) = 0d%0d", my_byte);
 
      // b) What is the value of my_int in hex?
      $display("my_int = 0x%0x", my_int);
  
      // c) What is the value of my_bit in decimal?
      $display("my_bit = 0d%0d", my_bit);

      // d) What is the value of my_short_int1 in decimal?
      $display("my_short_int1 = 0d%0d", my_short_int1);

      // e) What is the value of my_short_int2 in decimal?
       $display("my_short_int2 = 0d%0d", my_short_int2);
      
      $finish;
   end
   
endmodule // test

