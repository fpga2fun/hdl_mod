program automatic test (
    X_if xi[NUM_XI]
);

  vx_if vxi[NUM_XI];
  Driver driver[];

  initial begin
    // 构建阶段
    // 将局部虚拟接口连到顶层
    vxi = xi;  // 把接口数组赋值给本地虚拟接口数组
    driver = new[NUM_XI];

    foreach (vxi[i])  // 构建 NUM_XI 个驱动器
    driver[i] = new(vxi[i], i);

    // 复位阶段
    foreach (vxi[i])
    fork
      begin
        driver[i].reset();
        driver[i].load_op();
      end
    join
    //…
  end
endprogram
