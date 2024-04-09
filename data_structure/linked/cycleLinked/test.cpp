 #include<stdio.h>
#include<stdlib.h>
typedef struct list{
    int data;
    struct list *next;
}list;
//data为存储的数据，next指针为指向下一个结点
 
//初始结点
list *initlist(){
    list *head=(list*)malloc(sizeof(list));
    if(head==NULL){
        printf("创建失败，退出程序");
        exit(0);
    }else{
        head->next=NULL;
        return head;
    }
}
 
//创建--插入数据
int create_list(list *head){
    int data;   //插入的数据类型
    printf("请输入要插入的元素：");
    scanf("%d",&data);
 
    list *node=initlist();
    node->data=data;
    //初始化一个新的结点，准备进行链接
 
    if(head!=NULL){
        list *p=head;
        //找到最后一个数据
        while(p->next!=head){
            p=p->next;
        }
        p->next=node;
        node->next=head;
        return 1;
    }else{
        printf("头结点已无元素\n");
        return 0;
    }
 
}
 
//插入元素
list *insert_list(list *head,int pos,int data){
    //三个参数分别是链表，位置，参数
    list *node=initlist();  //新建结点
    list *p=head;       //p表示新的链表
    list *t;
    t=p;
    node->data=data;
    if(head!=NULL){
        for(int i=1;i<=pos;i++){
            t=t->next;
        }
        node->next=t->next;
        t->next=node;
        return p;
    }
    return p;
}
 
//删除元素
int delete_list(list *head) {
    if(head == NULL) {
        printf("链表为空！\n");
        return 0;
    }
    //建立零时结点存储头结点信息（目的为了找到退出点）
    //如果不这么建立的化需要使用一个数据进行计数标记，计数达到链表长度时自动退出
    //循环链表当找到最后一个元素的时候会自动指向头元素，这是我们不想让他发生的
    list *temp = head;          
    list *ptr = head->next;
 
    int del;
    printf("请输入你要删除的元素：");
    scanf("%d",&del);
 
    while(ptr != head) {
        if(ptr->data == del) {
            if(ptr->next == head) { //循环结束的条件换成ptr->next == head
                temp->next = head;
                free(ptr);
                return 1;
            }
            temp->next = ptr->next;
            free(ptr);
            //printf("元素删除成功！\n");
            return 1;
        }
        temp = temp->next;
        ptr = ptr->next;
    }
    printf("没有找到要删除的元素\n");
    return 0;
}
 
 
//遍历元素
int display(list *head) {
    if(head != NULL) {
        list *p  = head;
        //遍历头节点到，最后一个数据
        while(p->next != head ) {
            printf("%d   ",p->next->data);
            p = p->next;
        }
        printf("\n");   //习惯性换行 ( o=^•ェ•)o　┏━┓
        //把最后一个节点赋新的节点过去
        return 1;
    } else {
        printf("头结点为空!\n");
        return 0;
    }
}
 
int main(){
    //////////初始化头结点//////////////
    list *head=initlist();
    head->next=head;
    ////////通过插入元素完善链表/////////
    for(int i=0;i<5;i++){   //只是演示使用，不具体提供输入
        create_list(head);
    }
    display(head);
    ////////////插入元素////////////////
    head=insert_list(head,1,10);
    display(head);
    ////////////删除元素////////////////
    delete_list(head);
    display(head);
    return 0;
}