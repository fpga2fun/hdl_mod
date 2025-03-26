class UNI_cell extends BaseTr;
  // 物理域
  rand bit [3:0] GFC;
  rand bit [7:0] VPI;
  rand bit [15:0] VCI;
  rand bit CLP;
  rand bit [2:0] PT;
  bit [7:0] HEC;
  rand bit [0:47][7:0] Payload;

  // 数据域
  static bit [7:0] syndrome[0:255];
  static bit syndrome_not_generated = 1;

  extern function new();
  extern function void post_randomize();
  extern virtual function bit compare(input BaseTr to);
  extern virtual function void display(input string prefix = "");
  extern virtual function BaseTr copy(input BaseTr to = null);
  extern virtual function void pack(output ATMCellType to);
  extern virtual function void unpack(input ATMCellType from);
  extern function NNI_cell to_NNI();
  extern function void generate_syndrome();
  extern function bit [7:0] hec(bit [31:0] hdr);
endclass : UNI_cell
