#include<stdio.h>
#include<stdlib.h>
typedef struct line{
    int data;           //data
    struct line *pre;   //pre node
    struct line *next;  //next node
}line;
//分别表示该结点的前驱(pre)，后继(next)，以及当前数据(data)
 
//遍历双链表,同时打印元素数据
void printLine(line *head){
    line *list = head;
    int pos=1;
    while(list){
        printf("第%d个数据是:%d\n",pos++,list->data);
        list=list->next;
    }
}
 
//创建双链表
line* initLine(line * head){
    int number,pos=1,input_data;
    printf("请输入创建结点的大小\n");
    scanf("%d",&number);
    if(number<1){return NULL;} //输入非法直接结束
    //////头结点创建///////
    head=(line*)malloc(sizeof(line));
    head->pre=NULL;
    head->next=NULL;
    printf("输入第%d个数据\n",pos++);
    scanf("%d",&input_data);
    head->data=input_data;
 
    line * list=head;
    while (pos<=number) {
        line * body=(line*)malloc(sizeof(line));
        body->pre=NULL;
        body->next=NULL;
        printf("输入第%d个数据\n",pos++);
        scanf("%d",&input_data);
        body->data=input_data;
        
        list->next=body;
        body->pre=list;
        list=list->next;
    }
    return head;
}
 
//插入数据
line * insertLine(line * head,int data,int add){
    //三个参数分别为：进行此操作的双链表，插入的数据，插入的位置
    //新建数据域为data的结点
    line * temp=(line*)malloc(sizeof(line));
    temp->data=data;
    temp->pre=NULL;
    temp->next=NULL;
    //插入到链表头，要特殊考虑
    if (add==1) {
        temp->next=head;
        head->pre=temp;
        head=temp;
    }else{
        line * body=head;
        //找到要插入位置的前一个结点
        for (int i=1; i<add-1; i++) {
            body=body->next;
        }
        //判断条件为真，说明插入位置为链表尾
        if (body->next==NULL) {
            body->next=temp;
            temp->pre=body;
        }else{
            body->next->pre=temp;
            temp->next=body->next;
            body->next=temp;
            temp->pre=body;
        }
    }
    return head;
}
 
//删除元素
line * deleteLine(line * head,int data){
    //输入的参数分别为进行此操作的双链表，需要删除的数据
    line * list=head;
    //遍历链表
    while (list) {
        //判断是否与此元素相等
        //删除该点方法为将该结点前一结点的next指向该节点后一结点
        //同时将该结点的后一结点的pre指向该节点的前一结点
        if (list->data==data) {
            list->pre->next=list->next;
            list->next->pre=list->pre;
            free(list);
            printf("--删除成功--\n");
            return head;
        }
        list=list->next;
    }
    printf("Error:没有找到该元素，没有产生删除\n");
    return head;
}
 
int main(){
    line *head=NULL;
    printf("创建双链表操作\n"); 
    head=initLine(head);
    printLine(head);
//////////create line////////////
    printf("插入操作\n"); 
    head=insertLine(head,40,2);     //为了简化直接写参数了
    printLine(head);
//////////insert Line////////////
    printf("删除操作\n"); 
    head=deleteLine(head,2);       //为了简化直接写参数了
    printLine(head);
//////////delete Line////////////  
    return 0;
}