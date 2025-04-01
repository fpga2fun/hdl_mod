function void print_state();
  $display("@%0t: state = %s", $time, cur_state.name());
endfunction
