program automatic test (
    arb_if.TEST arbif
);
  initial begin
    $monitor("@%0t: grant = %h", $time, arbif.cb.grant);
    #500ns $display("End of test");
  end
endprogram

module arb_dummy(arb_if.DUT arbif);
 initial
 fork
 #70 ns arbif.grant = 1; 
 #170ns arbif.grant = 2; 
 #250ns arbif.grant = 3; 
 join
endmodule
