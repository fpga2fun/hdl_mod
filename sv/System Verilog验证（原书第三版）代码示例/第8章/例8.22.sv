class Transaction;
  virtual function Transaction copy(input Transaction to = null);
    if (to == null) copy = new();  // 创建新对象
    else copy = to;  // 或者使用现有对象
    copy.src  = this.src;  // 复制数据域
    copy.dst  = this.dst;
    copy.data = this.data;
    copy.csm  = this.csm;
    return copy;
  endfunction
endclass
