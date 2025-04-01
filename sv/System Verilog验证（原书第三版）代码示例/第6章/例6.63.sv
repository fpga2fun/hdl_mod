class randc8;
  randc bit [7:0] val;
endclass

class LittleUniqueArray;
  bit [7:0] ua[64];  // 每个元素具有唯一值的数组

  function void pre_randomize();
    randc8 rc8;
    rc8 = new();
    foreach (ua[i]) begin
      `SV_RAND_CHECK(rc8.randomize());
      ua[i] = rc8.val;
    end
  endfunction
endclass
