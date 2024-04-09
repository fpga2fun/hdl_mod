#include<stdio.h>
  
char *_strcat(char * dest,char * src){
    char * ret = dest;
    while(*dest!='\0'){dest++;}
    //将src内容复制在dest之后
    while(*src){
        *dest++ = *src++;
    }
    //在dest后面追加\0
    *dest = '\0';
    return ret;
}
  
int main(){
    char str[] = "Hello My DotCpp.com";
    char fixstr[] = "Welcome ";
    _strcat(fixstr,str);
  
    printf("%s",fixstr);
  
    return 0;
}