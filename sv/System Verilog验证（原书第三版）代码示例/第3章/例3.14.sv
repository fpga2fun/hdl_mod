print_csm(a); //a[0:size()-1] 中所有元素的校验和 —— 缺省情况
print_csm(a, 2, 4); //a[2:4] 中所有元素的校验和
print_csm(a, 1); // 从 a[1] 开始
print_csm(a,, 2); //a[0:2] 中所有元素的校验和
print_csm(); // 编译错误：a 没有缺省值