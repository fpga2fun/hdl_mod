class Config;
  rand bit [31:0] run_for_n_trans;
  constraint reasonable {run_for_n_trans inside {[1 : 1000]};}
endclass
