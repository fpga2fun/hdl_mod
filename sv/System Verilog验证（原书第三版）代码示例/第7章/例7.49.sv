program automatic test;

  Environment env;

  initial begin
    env = new();
    env.gen_cfg();
    env.build();
    env.run();
    env.wrap_up();
  end

endprogram
