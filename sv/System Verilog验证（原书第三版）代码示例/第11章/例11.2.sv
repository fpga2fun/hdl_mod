program automatic test #(
    parameter int NumRx = 4,
    parameter int NumTx = 4
) (
    Utopia.TB_Rx Rx[0:NumRx - 1],
    Utopia.TB_Tx Tx[0:NumTx - 1],
    cpu_ifc.Test mif,
    input logic rst
);

  `include "environment.sv"
Environment env;

  initial begin
    env = new(Rx, Tx, NumRx, NumTx, mif);
    env.gen_cfg();
    env.build();
    env.run();
    env.wrap_up();
  end
endprogram  // test
