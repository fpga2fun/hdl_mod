#include<iostream>
#include<cstdio>
#include<cstring>
using namespace std;
  
int *buildNext(char *P){
    int m = strlen(P) , j=0;
    int * N = new int[m];
    int t = N[0] = -1;
    while( j < m-1 ){
        if( 0 > t || P[j] == P[t] ){
            N[++j] = ++t;
        }
        else{
            t = N[t];
        }
    }
    return N;
}
  
int KMP(char T[],char P[]){ //T--主串,P--模式串
    int *next = buildNext(P);   //构造NEXT表
    int n = strlen(T) , i=0;
    int m = strlen(P) , j=0;
    while( j<m && i<n ){
        if( j<0 || T[i]==P[j] ){
            i++;
            j++;
        }else{
            j = next[j];
        }
         
    }
    delete []next;
    return i-j;
}
  
int main(){
  
    char org[] = "ABABAABAABAC";
    char str[] = "ABAABAC";
    int ans = KMP(org,str);
    cout << ans <<endl;
  
    return 0;
}