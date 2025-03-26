class Transaction;
  rand bit [1:0] src, dst;
  constraint c_dist {
    src dist {
      0 := 40,
      [1 : 3] := 60
    };
    //src = 0, weight = 40/220
    //src = 1, weight = 60/220
    //src = 2, weight = 60/220
    //src = 3, weight = 60/220

    dst dist {
      0 :/ 40,
      [1 : 3] :/ 60
    };
    //dst = 0, weight = 40/100
    //dst = 1, weight = 20/100
    //dst = 2, weight = 20/100
    //dst = 3, weight = 20/100
  }
endclass
