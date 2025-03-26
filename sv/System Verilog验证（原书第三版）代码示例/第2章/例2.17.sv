bit [3:0] [7:0] bytes;   // 4 个 字节 组装成 32 比特
bytes = 32'hCafe_Dada;
$displayh(bytes,,        // 显示所有32 比特
          bytes[3],,     // 最高字节 “CA”
          bytes[3][7]);  // “CA”的最高比特位“1”
