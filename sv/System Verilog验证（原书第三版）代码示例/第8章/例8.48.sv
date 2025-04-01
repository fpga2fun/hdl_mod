program automatic test;
  TestBase tb;
  initial begin
    tb = TestRegistry::get_test();
    tb.run_test();
  end
endprogram
