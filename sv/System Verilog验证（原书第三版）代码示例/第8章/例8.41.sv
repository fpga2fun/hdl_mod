int db_int[string];
function void db_int_set(input string name, input int value);
  db_int[name] = value;
endfunction

function void db_int_get(input string name, ref int value);
  value = db_int[name];
endfunction

function void db_int_print();
  foreach (db_int[i]) $display("db_int[%s] = %0d", i, db_int[i]);
endfunction
