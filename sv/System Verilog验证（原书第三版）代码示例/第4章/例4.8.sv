module bad_test(arb_if arbif);
`include "MyTest.sv" // 合法的 include 语句
`include "arb_if.sv" // 错误：接口隐藏在模块内部
...