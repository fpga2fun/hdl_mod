class Scoreboard;
  Transaction scb[$];  // 保存期望的事务的队列

  function void save_expected(input Transaction tr);
    scb.push_back(tr);
  endfunction

  function void compare_actual(input Transaction tr);
    int q[$];

    q = scb.find_index(x) with (x.src == tr.src);
    case (q.size())
      0: $display("No match found");
      1: scb.delete(q[0]);
      default: $display("Error, multiple matches found!");
    endcase
  endfunction : compare_actual
endclass : Scoreboard
