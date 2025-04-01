Transaction tr;
BadTr bad;

initial begin
  tr = new();
  tr.calc_csm();  // 调用 Transaction::calc_csm

  bad = new();
  bad.calc_csm();  // 调用 BadTr::calc_csm

  tr = bad;  // 基类句柄指向扩展对象
  tr.calc_csm();  // 调用 BadTr::calc_csm
end
