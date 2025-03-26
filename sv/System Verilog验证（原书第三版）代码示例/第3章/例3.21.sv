typedef int fixed_array5_t[5];
fixed_array5_t f5;

function fixed_array5_t init(input int start);
  foreach (init[i]) init[i] = i + start;
endfunction

initial begin
  f5 = init(5);
  foreach (f5[i]) $display("f5[%0d] = %0d", i, f5[i]);
end
