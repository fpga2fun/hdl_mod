class Transaction;
  rand bit [31:0] src, dst, data[8];  // 变量
  bit [31:0] csm;

  virtual function Transaction copy();
    copy = new();  // 构造目标对象
    copy.src = this.src;  // 复制数据域
    copy.dst = this.dst;  // 前缀 “this.” 不是必需的，但让代码更清楚
    copy.data = this.data;
    copy.csm = this.csm;
    return copy;  // 返回要 copy 的句柄
  endfunction
endclass
