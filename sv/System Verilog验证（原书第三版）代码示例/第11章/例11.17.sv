function UNI_cell::new();
 if (syndrome_not_generated)
 generate_syndrome();
endfunction : new

// 在所有其他数据都确定后计算 HEC
function void UNI_cell::post_randomize();
 HEC = hec({GFC, VPI, VCI, CLP, PT});
endfunction : post_randomize
// 和其他信元比较
// 可以进一步改进，返回不匹配的域
function bit UNI_cell::compare(input BaseTr to);
 UNI_cell c;
 $cast(c, to);
 if (this.GFC != c.GFC) return 0;
 if (this.VPI != c.VPI) return 0;
 if (this.VCI != c.VCI) return 0;
 if (this.CLP != c.CLP) return 0;
 if (this.PT != c.PT) return 0;
 if (this.HEC != c.HEC) return 0;
 if (this.Payload != c.Payload) return 0;
 return 1;
endfunction : compare

// 输出信元各个域的详细内容
function void UNI_cell::display(input string prefix);
 ATMCellType p;

 $display("%sUNI id:%0d GFC = %x, VPI = %x, VCI = %x, CLP = %b, PT = %x,
 HEC = %x, Payload[0] = %x",
 prefix, id, GFC, VPI, VCI, CLP, PT, HEC, Payload[0]);
 this.pack(p);
 $write("%s", prefix);
 foreach (p.Mem[i]) $write("%x ", p.Mem[i]);
 $display;
endfunction : display

// 复制对象
function BaseTr UNI_cell::copy(input BaseTr to);
 if (to == null) copy = new();
 else $cast(copy, to);
 copy.GFC = this.GFC;
 copy.VPI = this.VPI;
 copy.VCI = this.VCI;
 copy.CLP = this.CLP;
 copy.PT = this.PT;
 copy.HEC = this.HEC;
 return copy;
endfunction : copy

// 把对象打包到一个字节数组
function void UNI_cell::pack(output ATMCellType to);
 to.uni.GFC = this.GFC;
 to.uni.VPI = this.VPI;
 to.uni.VCI = this.VCI;
 to.uni.CLP = this.CLP;
 to.uni.PT = this.PT;
 to.uni.HEC = this.HEC;
 to.uni.Payload = this.Payload;
endfunction : pack

// 把字节数组的内容展开到 this 对象
function void UNI_cell::unpack(input ATMCellType from);
 this.GFC = from.uni.GFC;
 this.VPI = from.uni.VPI;
 this.VCI = from.uni.VCI;
 this.CLP = from.uni.CLP;
 this.PT = from.uni.PT;
 this.HEC = from.uni.HEC;
 this.Payload = from.uni.Payload;
endfunction : unpack

// 根据 UNI 信元产生 NNI 信元，在计分板使用
function NNI_cell UNI_cell::to_NNI();
 NNI_cell copy;
 copy = new();
 copy.VPI = this.VPI; // NNI 信元的 VPI 更宽
 copy.VCI = this.VCI;
 copy.CLP = this.CLP;
 copy.PT = this.PT;
 copy.HEC = this.HEC;
 copy.Payload = this.Payload;
 return copy;
endfunction : to_NNI

// 产生用于计算 HEC 的 syndrome 数组
function void UNI_cell::generate_syndrome();
 bit [7:0] sndrm;
 for (int i = 0; i < 256; i = i + 1 ) begin
 sndrm = i;
 repeat (8) begin
 if (sndrm[7] === 1'b1)
 sndrm = (sndrm << 1) ^ 8'h07;
 else
 sndrm = sndrm << 1;
 end
 syndrome[i] = sndrm;
 end
 syndrome_not_generated = 0;
endfunction : generate_syndrome

// 计算对象的 HEC
function bit [7:0] UNI_cell::hec (bit [31:0] hdr);
 hec = 8'h00;
 repeat (4) begin
 hec = syndrome[hec ^ hdr[31:24]];
 hdr = hdr << 8;
 end
 hec = hec ^ 8'h55;
endfunction : hec