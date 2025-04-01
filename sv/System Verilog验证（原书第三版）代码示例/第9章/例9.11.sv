program automatic test (
    simple_bus sb
);

  covergroup Write_cg @($root.top.m1.write_event);
    coverpoint $root.top.m1.data;
    coverpoint $root.top.m1.addr;
  endgroup

  Write_cg wcg;

  initial begin
    wcg = new();
    sb.write_ena <= 1;  // 在此处添加激励
    #10000ns $finish;
  end
endprogram
