initial begin
  byte twoD[4][6];
  foreach (twoD[i, j]) twoD[i][j] = i * 10 + j;

  foreach (twoD[i]) begin  // 遍历第一个维度
    $write("%2d:", i);
    foreach (twoD[, j])  // 遍历第二个维度
    $write("%3d", twoD[i][j]);
    $display;
  end
end
