program automatic test_with_cb (
    arb_if.TEST arbif
);
  initial
  fork
    #70ns arbif.cb.request <= 3;
    #170ns arbif.cb.request <= 2;
    #250ns arbif.cb.request <= 1;
    #500ns finish;
  join
endprogram

module arb (
    arb_if.DUT arbif
);
  initial $monitor("@%0t: req = %h", $time, arbif.request);
endmodule
