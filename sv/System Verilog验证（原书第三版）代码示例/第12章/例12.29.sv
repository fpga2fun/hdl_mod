typedef struct packed {bit [7:0] r, g, b;} RGB_T;
import "DPI-C" function void invert(inout RGB_T pstruct);

program automatic test;

  class RGB;
    rand bit [7:0] r, g, b;
    function void display(input string prefix = "");
      $display("%sRGB = %x,%x,%x", prefix, r, g, b);
    endfunction : display

    // 将类成员压缩到一个结构中
    function RGB_T pack();
      pack.r = r;
      pack.g = g;
      pack.b = b;
    endfunction : pack

    // 将结构解压后赋值给类成员
    function void unpack(RGB_T pstruct);
      r = pstruct.r;
      g = pstruct.g;
      b = pstruct.b;
    endfunction : unpack
  endclass : RGB

  initial begin
    RGB   pixel;
    RGB_T pstruct;

    pixel = new;
    repeat (5) begin
      `SV_RAND_CHECK(pixel.randomize());  // 创建随机像素
      pixel.display("\nSV: before ");  // 打印像素值
      pstruct = pixel.pack();  // 转换为结构
      invert(pstruct);  // 调用 C 函数将位取反
      pixel.unpack(pstruct);  // 把结构解压后赋值给类
      pixel.display("SV: after ");  // 打印
    end
  end
endprogram
