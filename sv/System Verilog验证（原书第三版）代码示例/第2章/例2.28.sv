// 声明并初始化一个有 7 个元素的关联数组
int aa[int] = '{0:1,5:2,10:4,15:8,20:16,25:32,30:64};
int idx,element,count;

element = $urandom_range(aa.size()-1);
foreach(aa[i])
 if (count++ == element) begin
 idx = i; // 保存关联数组的索引
 break; // 退出
 end
 
$display("element#%0d aa[%0d] = %0d",
 element,idx,aa[idx])