class UniqueArray;
  int max_array_size, max_value;
  rand bit [15:0] ua[];  // 每个元素具有唯一值的数组
  constraint c_size {ua.size() inside {[1 : max_array_size]};}

  function new(input int max_array_size = 2, max_value = 2);
    this.max_array_size = max_array_size;
    // 如果 max_value 小于数组的大小，那么说明数组里有重复的值，所以要调整 max_value
    if (max_value < max_array_size) this.max_value = max_array_size;
    else this.max_value = max_value;
  endfunction

  // 在 randomize() 函数里分配数组 ua[]，并填充唯一值
  function void post_randomize();
    RandcRange rr;
    rr = new(max_value);
    foreach (ua[i]) begin
      `SV_RAND_CHECK(rr.randomize());
      ua[i] = rr.value;
    end
  endfunction

  function void display();
    $write("Size: %3d:", ua.size());
    foreach (ua[i]) $write("%4d", ua[i]);
    $display;
  endfunction
endclass
