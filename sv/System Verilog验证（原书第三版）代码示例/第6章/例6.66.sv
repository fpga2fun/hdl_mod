program automatic test;
  UniqueArray ua;
  initial begin
    ua = new(50);  // 数组大小 = 50

    repeat (10) begin
      `SV_RAND_CHECK(ua.randomize());  // 产生随机数组
      ua.display();  // 显示数组内容
    end
  end
endprogram
