Transaction tr;
BadTr bad,bad2;

bad = new(); // 构建 BadTr 扩展对象
tr = bad; // 基类句柄指向扩展对象

// 检查对象类型并且拷贝，如果类型失配则在仿真时报错
// 如果成功，bad2 就指向 tr 所引用的对象
$cast(bad2, tr);

// 检查类型是否失配，如果类型失配，在仿真时也不会输出错误信息
if($cast(bad2, tr))
 $dislay(bad2.bad_csm); // 原始对象中存在 bad_csm 成员
else
 $display("ERROR: cannot assign tr to bad2");