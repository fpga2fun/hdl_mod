program automatic test (
    arb_if.TEST arbif
);
  initial begin
    @arbif.cb;
    arbif.cb.request <= 2'b01;
    $display("@%0t: Drove req = 01", $time);
    repeat (2) @arbif.cb;
    if (arbif.cb.grant == 2'b01) $display("@%0t: Success: grant == 2'b01", $time);
    else $display("@%0t: Error: grant != 2'b01", $time);
  end
endprogram : test
