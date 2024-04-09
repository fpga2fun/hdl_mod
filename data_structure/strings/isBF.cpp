#include<iostream>
#include<cstring>
#include<cstdio>

using namespace std;
  
bool isBF(char * str1,char * str2){
    bool flag=false;
    int len1 = strlen(str1);
    int len2 = strlen(str2);
    for(int i=0;i<len1;i++){
        for(int j=0;j<len2;j++){
            int pos=i;
            if( str1[pos++] != str2[j]){
                break;
            }else{
                if(j=len2-1)
                    flag=true;
            }
        }
    }
    return flag;
}
  
int main(){
    char str1[] = "HI this is my lesson.";
    char str2[] = "his";
    cout<<isBF(str1,str2)<<endl;
    return 0;
}