int power_of_2[int] = '{0: 1, 1: 2, 2: 4};
initial begin
  for (int i = 3; i < 5; i++) power_of_2[i] = 1 << i;
  $display("%p", power_of_2);  //'{0:1，1:2，2:4，3:8，4:16}
end
