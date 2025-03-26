initial begin
  bit [31:0] src[5] = '{5{5}};
  $displayb(src[0],,  // 'b101 或 'd5
            src[0][0],,  // 'b1
            src[0][2:1]);  // 'b10
end
