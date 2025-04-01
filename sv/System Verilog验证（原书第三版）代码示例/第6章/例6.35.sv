class Bathtub;
  int value;  // 浴缸型分布的随机变量
  int WIDTH = 50, DEPTH = 6, seed = 1;

  function void pre_randomize();
    // 计算指数曲线
    value = $dist_exponential(seed, DEPTH);
    if (value > WIDTH) value = WIDTH;

    // 把这一个点随机放在左边或右边的曲线上
    if ($urandom_range(1))  // 随机数 0 或 1
      value = WIDTH - value;
  endfunction

endclass
