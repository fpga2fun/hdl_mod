import "DPI-C" function void view_pack(input bit [63:0] b64[]);

program automatic test;
  bit [1:0][0:3][6:-1] bpack[9:1];

  initial begin
    foreach (bpack[i]) bpack[i] = i;
    bpack[2] = 64'h12345678_90abcdef;

    $display("SV: bpack[2] = %h", bpack[2]);  // 64 位
    $display("SV: bpack[2][0] = %h", bpack[2][0]);  // 32 位
    $display("SV: bpack[2][0][0] = %h", bpack[2][0][0]);  // 8 位

    view_pack(bpack);
  end
endprogram : test
