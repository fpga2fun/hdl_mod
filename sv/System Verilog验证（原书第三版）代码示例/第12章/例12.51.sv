import "DPI-C" function int call_perl(string s);

program automatic perl_test;
  int ret_val;
  string script;

  initial begin
    $value$plusargs("script = %s", script);
    $display("SV: Running '%0s'", script);
    ret_val = call_perl(script);
    $display("SV: Perl script returned %0d", ret_val);
  end
endprogram : perl_test
