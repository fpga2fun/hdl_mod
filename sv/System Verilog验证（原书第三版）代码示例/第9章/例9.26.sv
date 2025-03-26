bit [2:0] dst;
covergroup CovDst26;
  coverpoint tr.dst {wildcard bins even = {3'b??0}; wildcard bins odd = {3'b??1};}
endgroup
