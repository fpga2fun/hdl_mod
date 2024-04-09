#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#define maxn 10000
 
//结点设计
typedef struct stack{
    int data[maxn];
    int top;
}stack;
 
//创建
stack *init(){
    stack *s=(stack *)malloc(sizeof(stack));
    if(s==NULL){
        printf("分配内存空间失败");
        exit(0);
    }
    memset(s->data,0,sizeof(s->data));
    //memset操作来自于库文件string.h，其表示将整个空间进行初始化
    //不理解可以查阅百度百科https://baike.baidu.com/item/memset/4747579?fr=aladdin
    s->top=0;     //栈的top和bottom均为0（表示为空）
    return s;
}
 
//入栈push
void push(stack *s,int data){
    s->data[s->top]=data;
    s->top++;
}
 
//出栈pop
void pop(stack *s){
    if(s->top!=0){
        s->data[s->top]=0;  //让其回归0模拟表示未初始化即可
        s->top--;
    }
}
 
//模拟打印栈中元素
void print_stack(stack *s){
    for(int n=s->top-1;n>=0;n--){
        printf("%d\t",s->data[n]);
    }
    printf("\n");   //习惯性换行
}
 
int main(){
    stack *s=init();
    int input[5]={11,22,33,44,55};  //模拟五个输入数据
    for(int i=0;i<5;i++){
        push(s,input[i]);
    }
    print_stack(s);
    /////////////
    for(int i=0;i<5;i++){
        pop(s);
        print_stack(s);
    }
    return 0;
}