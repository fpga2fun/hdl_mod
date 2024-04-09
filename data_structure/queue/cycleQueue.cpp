#include<stdio.h>
#include<stdlib.h>
#include<cstring>
#define maxsize 10      //表示循环队列的最大容量
 
//循环队列的结构设计
typedef struct cir_queue{
    int data[maxsize];
    int rear;
    int front;
}cir_queue;
 
//初始化
cir_queue *init(){
    cir_queue *q = (cir_queue*)malloc(sizeof(cir_queue));
    if(q==NULL){
        exit(0);    //申请内存失败，退出程序
    }
    memset(q->data,0,sizeof(q->data));
    q->front=0;
    q->rear=0;
    return q;
}
 
//入队操作push
void push(cir_queue *q,int data){
    if((q->rear+1)%maxsize==q->front){
        printf("溢出，无法入队\n");
        return;
    }else{
        q->rear=(q->rear+1)%maxsize;
        q->data[q->rear]=data;
    }
}
 
//出队操作pop
void pop(cir_queue *q){
    if(q->rear==q->front){
        printf("队列为空，无法出队\n");
        return;
    }else{
        q->data[q->front]=0;
        q->front=(q->front+1)%maxsize;
    }
}
 
//遍历队列
void print(cir_queue *q){
    int i=q->front;
    while(i!=q->rear){
        i=(i+1)%maxsize;
        printf("%d\t",q->data[i]);   
    }
    printf("\n");       //记得换行
}
 
int main(){
    cir_queue *q = init();
    ////////////入队操作///////////////
    printf("入队操作\n");
    for(int i=1;i<=6;i++){
        push(q,i);
    }
    print(q);
    ////////////出队操作///////////////
    printf("出队操作\n");
    for(int i=1;i<=3;i++){
        pop(q);
        print(q);
    }
    return 0;
}