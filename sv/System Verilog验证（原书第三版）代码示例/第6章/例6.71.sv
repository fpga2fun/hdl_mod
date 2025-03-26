class LenDist;
  rand bit [15:0] len;
  constraint c {
    len dist {
      [0 : 2] := 1,
      [3 : 5] := 8,
      [6 : 7] := 1
    };
  }
endclass

initial begin
  LenDist lenD;
  lenD = new();
  `SV_RAND_CHECK(lenD.randomize());
  $display("len=%0d", lenD.len);
end
