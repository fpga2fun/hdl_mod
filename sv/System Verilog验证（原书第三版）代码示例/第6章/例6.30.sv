class Imp2;
  rand bit x;  //0 或 1
  rand bit [1:0] y;  //0, 1, 2 或 3
  constraint c_xy {
    y > 0;
    (x == 0) -> y == 0;
  }
endclass
