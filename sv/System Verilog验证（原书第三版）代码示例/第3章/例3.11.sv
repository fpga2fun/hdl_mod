function automatic void print_csm11(const ref bit [31:0] a[]);
  bit [31:0] checksum = 0;
  for (int i = 0; i < a.size(); i++) checksum ^= a[i];
  $display("The array checksum is %0d", checksum);
endfunction
