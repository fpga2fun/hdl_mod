program automatic test #(
    NUM_XI = 2
);

  virtual X_if.TB vxi[NUM_XI];  // 虚拟接口数组
  Driver driver[];

  initial begin
    // 将局部虚拟接口连到顶层
    vxi = top.xi;

    // 创建 N 个驱动器对象
    driver = new[NUM_XI];
    foreach (driver[i]) driver[i] = new(vxi[i], i);

    foreach (driver[i]) begin
      automatic int j = i;
      fork
        begin
          driver[j].reset();
          driver[j].load_op();
        end
      join_none
    end

    repeat (10) @(vxi[0].cb);
  end
endprogram
