/*///////////////////////////////////////////////////////////////////
// Purpose: Call hello_sv for 2 hello SystemVerilog objects
// for Chap_12_Interfacing_with_C/exercise6_slide
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: hello.c,v $
// Revision 1.1  2011/09/27 19:54:23  tumbush.tumbush
// Initial check-in
//
//
////////////////////////////////////////////////////////////////////*/


#include <svdpi.h>
#include <stdio.h>
extern void hello_build();
extern void hello_sv();
void hello() {
  hello_build();
  hello_build();
  hello_sv(0);
  hello_sv(1);
}
