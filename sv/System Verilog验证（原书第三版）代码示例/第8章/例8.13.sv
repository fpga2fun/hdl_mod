tr = new(); // 创建一个基类对象
bad = tr; //ERROR: 这一行不会被编译
$display(bad.bad_csm); // 基类对象不存在 bad_csm 成员