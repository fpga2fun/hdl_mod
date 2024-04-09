#include<stdio.h>
  
int _strcmp (char  *  src, char  *  dst)   {   
    int  ret  =  0  ;   
    while(  !(ret  =  *(unsigned  char  *)src  -  *(unsigned  char  *)dst)  &&  *dst)   //两个内容相减，完全相等则会得到值 0，取反即为相等
        ++src,  ++dst;   
    if  (  ret  <  0  )   
        ret  =  -1  ;   
    else  if  (  ret  >  0  )   
        ret  =  1  ;   
    return ret;   
} 
  
int main(){
    char str[] = "Hello My DotCpp.com";
    char fixstr[] = "Welcome ";
    int ans = _strcmp(fixstr,str);
  
    printf("%d",ans);
  
    return 0;
}