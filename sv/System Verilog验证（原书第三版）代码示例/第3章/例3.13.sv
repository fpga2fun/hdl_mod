function automatic void print_csm(const ref bit [31:0] a[], input bit [31:0] low = 0,
                                  input int high = -1);
  bit [31:0] checksum = 0;

  if (high == -1 || high >= a.size()) high = a.size() - 1;

  for (int i = low; i <= high; i++) checksum ^= a[i];
  $display("The array checksum is %h", checksum);
endfunction
