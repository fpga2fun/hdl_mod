class config_db #(
    type T = int
);
  T db[string];
  function void set(input string name, input T value);
    db[name] = value;
  endfunction

  function void get(input string name, ref T value);
    value = db[name];
  endfunction

  function void print();
    $display("Configuration database %s", $typename(T));
    foreach (db[i]) $display("db[%s] = %p", i, db[i]);
  endfunction
endclass
