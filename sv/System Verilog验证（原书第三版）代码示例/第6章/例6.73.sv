bit [31:0] state = 32'h12345678;
function bit [31:0] my_random();
  bit [63:0] s64;
  s64   = state * state;
  state = (s64 >> 16) + state;
  return state;
endfunction
