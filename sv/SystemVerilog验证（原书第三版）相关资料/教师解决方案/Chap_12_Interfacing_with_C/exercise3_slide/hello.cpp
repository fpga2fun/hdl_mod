/////////////////////////////////////////////////////////////////////
// Purpose: hello_cnt class for Chap_12_Interfacing_with_C/exercise3_slide
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: hello.cpp,v $
// Revision 1.1  2011/09/27 19:39:53  tumbush.tumbush
// Initial check-in
//
//
/////////////////////////////////////////////////////////////////////


#include <svdpi.h>
#include <stdio.h>

class hello_cnt{
public:
  hello_cnt(); // Constructor
  void hello_c();

private:
  unsigned int cnt;
};


/* Construct a counter structure */
hello_cnt::hello_cnt()
{
  cnt = 0;
}

/* Run the counter for one cycle */
void hello_cnt::hello_c() 
{
    printf("Hello World count=%d\n", cnt++);
}

extern "C" {

  void* hello_new() 
  {
    return new hello_cnt();
  }

  void hello_c(void* inst)
  {
    hello_cnt *hc = (hello_cnt *) inst;
    hc->hello_c();
  }
}
