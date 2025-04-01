bit [2:0] dst_a, dst_b;

covergroup CovDst40(ref bit [2:0] dst, input int mid);
  coverpoint dst {bins lo = {[0 : mid - 1]}; bins hi = {[mid : $]};}
endgroup

CovDst40 cpa, cpb;
initial begin
  cpa = new(dst_a, 4);  // dst_a, lo = 0:3, hi = 4:7
  cpb = new(dst_b, 2);  // dst_b, lo = 0:1, hi = 2:7
end
