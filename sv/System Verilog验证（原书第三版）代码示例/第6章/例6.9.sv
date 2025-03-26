// 总线操作：字节、字或长字
class BusOp;
  // 操作数长度
  typedef enum {
    BYTE,
    WORD,
    LWRD
  } length_e;
  rand length_e len;

  //dist 约束的权重
  bit [31:0] w_byte = 1, w_word = 3, w_lwrd = 5;

  constraint c_len {
    len dist {
      BYTE := w_byte,  // 使用可变的权重
      WORD := w_word,  // 选择随机的操作数长度
      LWRD := w_lwrd
    };
  }
endclass
