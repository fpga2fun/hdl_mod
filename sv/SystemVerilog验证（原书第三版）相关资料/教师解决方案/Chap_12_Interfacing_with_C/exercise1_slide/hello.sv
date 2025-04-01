//////////////////////////////////////////////////////////////////////////
// Purpose: SystemVerilog module for Chap_12_Interfacing_with_C/exercise1
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: hello.sv,v $
// Revision 1.1  2011/09/27 19:28:34  tumbush.tumbush
// Moved to exercise1_slide
//
// Revision 1.1  2011/05/26 03:20:36  tumbush.tumbush
// Moved repository to cloud
//
// Revision 1.1  2011/05/25 16:28:10  Greg
// Initial check-in
//
//////////////////////////////////////////////////////////////////////////
module hello;
   import "DPI-C" context function void hello_c();

    initial
     begin
	hello_c();
        $finish;
     end


endmodule
