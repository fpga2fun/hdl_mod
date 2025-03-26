program automatic bad_generator (
    output bit clk,
    data
);
  initial forever #5 clk <= ~clk;

  initial forever @(posedge clk) data <= ~data;
endprogram
