class bad_sum1;
  rand byte len[];
  constraint c_len {
    len.sum() < 1024;
    len.size() inside {[1 : 8]};
  }

  function void display();
    $write("sum = %4d, val = ", len.sum());
    foreach (len[i]) $write("%4d ", len[i]);
    $display;
  endfunction
endclass
