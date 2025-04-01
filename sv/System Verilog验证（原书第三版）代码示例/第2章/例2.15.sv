initial begin
    bit [31:0] src[5] = '{0,1,2,3,4},
               dst[5] = '{5,4,3,2,1};

    // 两个数组的聚合比较（只支持==和!=两种比较）
    if (src==dst)
        $display("src == dst");
    else
        $display("src != dst");

    // 把 src 所有元素值复制给dst
    dst = src;

    // 只改变一个元素的值
    src[0] = 5;

    // 所有元素的值是否相等 (否！)
    $display("src %s dst", (src == dst) ? "==" : "!=");

    // 使用数组片段对第 1-4 个元素进行比较（结果是相等的）
    $display("src[1:4] %s dst [1:4]",
              src[1:4] == dst[1:4]) ? "==" : "!=");
end
