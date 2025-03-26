class Transaction;
  rand bit [3:0] kind;
  rand bit [2:0] dst;
endclass

Transaction tr;
covergroup CovDst30;
  kind: coverpoint tr.kind;  // 创建覆盖点 kind
  dst: coverpoint tr.dst;  // 创建覆盖点 dst
  cross kind, dst;  // 把 kind 和 dst 交叉
endgroup
