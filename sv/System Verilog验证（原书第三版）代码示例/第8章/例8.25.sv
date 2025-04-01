class Transaction extends BaseTr;
  rand bit [31:0] src, dst, csm, data[8];

  extern function new();
  extern virtual function bit compare(input BaseTr to);
  extern virtual function BaseTr copy(input BaseTr to = null);
  extern virtual function void display(input string prefix = "");

endclass

function Transaction::new();
  super.new();
endfunction : new

function bit Transaction::compare(input BaseTr to);
  Transaction tr;
  if (!$cast(tr, to));  // 检查 to 是否为正确类型
  $finish;
  return ((this.src == tr.src) &&
 (this.dst == tr.dst) &&
 (this.csm == tr.csm) &&
 (this.data == tr.data));
endfunction : compare

function BaseTr Transaction::copy(input BaseTr to = null);
  Transaction cp;
  if (to == null) cp = new();
  else $cast(cp, to);
  cp.src  = this.src;  // 复制数据域
  cp.dst  = this.dst;
  cp.data = this.data;
  cp.csm  = this.csm;
  return cp;
endfunction : copy

function void Transaction::display(input string prefix = "");
  $display("%sTransaction %0d src = %h, dst = %x, csm = %x", prefix, id, src, dst, csm);
endfunction : display
