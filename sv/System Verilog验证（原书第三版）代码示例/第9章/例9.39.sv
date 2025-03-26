class Transaction;
 bit [2:0] dst; // 值：0:7
endclass
Transaction tr;

covergroup CovDst39 (int mid);
 coverpoint tr.dst
 {bins lo = {[0:mid-1]};
 bins hi = {[mid:$]};
 }
endgroup

CovDst39 cp;
initial
 cp = new(5); // lo = 0:4, hi = 5:7
 ...