//////////////////////////////////////////////////////////////////////////
// Purpose: SRAM Interface for Chap_6_Randomization/homework_solution
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: sram_if.sv,v $
// Revision 1.1  2011/05/29 19:10:04  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/20 19:09:52  Greg
// Initial check in
//
///////////////////////////////////////////////////////////////////////////
interface sram_if;
   bit [20:0] A;
   bit CE_b;
   bit WE_b;
   bit OE_b;
   wire [7:0] DQ;
      
   modport master (output A, CE_b, WE_b, OE_b, inout DQ);

 endinterface
