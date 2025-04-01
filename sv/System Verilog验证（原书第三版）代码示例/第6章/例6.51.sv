program automatic test;
  bad_sum1 c;
  initial begin
    c = new();
    repeat (5) begin
      `SV_RAND_CHECK(c.randomize());
      c.display();
    end
  end
endprogram
