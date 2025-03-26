function automatic void init(ref int f[5], input int start);
  foreach (f[i]) f[i] = i + start;
endfunction

int fa[5];
initial begin
  init(fa, 5);
  foreach (fa[i]) $display("fa[%0d] = %0d", i, fa[i]);
end
