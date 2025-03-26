/////////////////////////////////////////////////////////////////////////
// Purpose: DUT for Chap_7_Threads_and_Interprocess_Communicaton/exercise7
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: dut.sv,v $
// Revision 1.1  2011/05/29 19:13:47  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/05/10 23:26:07  Greg
// Initial check-in
//
/////////////////////////////////////////////////////////////////////////
module dut(my_if my_bus);

  always @(posedge my_bus.clk) begin
     my_bus.out1 = $random;
     my_bus.out2 = $random;
  end
   
endmodule // dut
