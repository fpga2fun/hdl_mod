/*//////////////////////////////////////////////////////////////////////////////// 
// Purpose: C-code for Chap_12_Interfacing_with_C/exercise2b_slide
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: hello.c,v $
// Revision 1.1  2011/09/27 19:36:23  tumbush.tumbush
// Initial check-in
//
//
/////////////////////////////////////////////////////////////////////////////////*/

#include <svdpi.h>
#include <malloc.h>
#include <stdio.h>
typedef struct { /* Structure to hold counter value */
  unsigned int cnt;
} hello_cnt;

hello_cnt *hello_cnt_ptr;

/* Construct a counter structure */
void* hello_new(unsigned int start_val) {
  hello_cnt_ptr = malloc(sizeof(hello_cnt));
  hello_cnt_ptr->cnt = start_val;
  return hello_cnt_ptr;
}

/* Run the counter for one cycle */
void hello_c(hello_cnt *inst) {
    printf("Hello World count=%d\n", inst->cnt++);
}
