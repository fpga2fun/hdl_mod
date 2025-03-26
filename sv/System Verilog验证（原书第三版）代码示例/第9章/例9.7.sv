class Driver_cbs_coverage extends Driver_cbs;
 covergroup CovDst7;
 ...
 endgroup
 virtual task post_tx(ref Transaction tr);
 CovDst7.sample(); // 采样覆盖率数值
 endtask
endclass