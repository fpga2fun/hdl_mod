covergroup CovDst43(int lo,hi, string comment);
 option.comment = comment;
 option.per_instance = 1;
 coverpoint tr.dst
 {bins range = {[lo:hi]};
 }
endgroup
...
CovDst43 cp_lo = new(0,3, "Low dst numbers");
CovDst43 cp_hi = new(4,7, "High dst numbers");