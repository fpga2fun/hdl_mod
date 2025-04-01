initial begin
  RandcInside ri;

  ri = new('{1, 3, 5, 7, 9, 11, 13});
  repeat (ri.array.size()) begin
    `SV_RAND_CHECK(ri.randomize());
    $display("Picked %2d [%0d]", ri.pick(), ri.index);
  end
end
