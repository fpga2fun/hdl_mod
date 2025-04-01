class BadTr extends Transaction;
  rand bit bad_csm;

  virtual function Transaction copy();
    BadTr bad;
    bad = new();  // 构造派生的对象
    bad.src = this.src;  // 复制数据域
    bad.dst = this.dst;
    bad.data = this.data;
    bad.csm = this.csm;
    bad.bad_csm = this.bad_csm;
    return bad;  // 返回要 copy 的句柄
  endfunction
endclass : BadTr
