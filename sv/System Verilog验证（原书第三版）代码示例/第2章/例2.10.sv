initial begin
  bit [31:0] src[5], dst[5];
  for (int i = 0; i < $size(src); i++) src[i] = i;  //初始化src数组
  foreach (dst[j]) dst[j] = src[j] * 2;  // dst 的值是 src 的两倍
end
