module hw (

);
reg clk;
reg rstn;
always #20 clk = ~clk;
dut dutInst ();
    initial begin: dump_hw_top
        (* qiwc *) $dumpvars  (0, dut);//Dump all ports of an instance 
    end
endmodule