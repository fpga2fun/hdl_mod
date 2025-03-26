class BadTr extrands Transaction;

 virtual function Transaction copy(input Transaction to = null);
 BadTr bad;
 if (to == null)
 bad = new(); // 创建一个新对象
 else
 $cast(bad,to); // 重用现有的对象
 super.copy(bad); // 复制基类数据域
 bad.bad_csm = this.bad_csm; // 复制扩展数据域
 return bad;
 endfunction
endclass : BadTr