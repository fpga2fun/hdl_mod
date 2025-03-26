class Coverage;
  bit [1:0] src;
  bit [NumTx - 1:0] fwd;

  covergroup CG_Forward;
    coverpoint src {bins src[] = {[0 : 3]}; option.weight = 0;}
    coverpoint fwd {
      bins fwd[] = {[1 : 15]};  // 忽略 fwd == 0
      option.weight = 0;
    }
    cross src, fwd;
  endgroup : CG_Forward

  function new();
    CG_Forward = new;  // 例化 covergroup
  endfunction : new

  // 采样输入数据
  function void sample (input bit [1:0] src, input bit [NumTx - 1:0] fwd);
    $display("@%0t: Coverage: src = %d. FWD = %b", $time, src, fwd);
    this.src = src;
    this.fwd = fwd;
    CG_Forward.sample();
  endfunction : sample
endclass : Coverage
