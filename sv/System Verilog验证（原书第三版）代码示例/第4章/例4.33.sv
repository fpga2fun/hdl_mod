// 没有接口声明，该模块不会被正确编译
module uses_an_interface (
    arb_ifc.DUT arbif
);
  initial arbif.grant = 0;
endmodule
