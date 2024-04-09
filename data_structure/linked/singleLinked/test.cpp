#include <stdio.h>
#include <stdlib.h>
 
//定义结点类型
typedef struct Node {
    int data;           //数据类型，你可以把int型的data换成任意数据类型，包括结构体struct等复合类型
    struct Node *next;          //单链表的指针域
} Node,*LinkedList;
 
//单链表的初始化
LinkedList LinkedListInit() {
    Node *L;
    L = (Node *)malloc(sizeof(Node));   //申请结点空间
    if(L==NULL){    //判断申请空间是否失败
        exit(0);    //如果失败则退出程序
    }
    L->next = NULL;          //将next设置为NULL,初始长度为0的单链表
    return L;
}
 
//单链表的建立1，头插法建立单链表
LinkedList LinkedListCreatH() {
    Node *L;
    L = (Node *)malloc(sizeof(Node));   //申请头结点空间
    L->next = NULL;                      //初始化一个空链表
 
    int x;                         //x为链表数据域中的数据
    while(scanf("%d",&x) != EOF) {
        Node *p;
        p = (Node *)malloc(sizeof(Node));   //申请新的结点
        p->data = x;                     //结点数据域赋值
        p->next = L->next;                    //将结点插入到表头L-->|2|-->|1|-->NULL
        L->next = p;
    }
    return L;
}
 
 
//单链表的建立2，尾插法建立单链表
LinkedList LinkedListCreatT() {
    Node *L;
    L = (Node *)malloc(sizeof(Node));   //申请头结点空间
    L->next = NULL;                  //初始化一个空链表
    Node *r;
    r = L;                          //r始终指向终端结点，开始时指向头结点
    int x;                         //x为链表数据域中的数据
    while(scanf("%d",&x) != EOF) {
        Node *p;
        p = (Node *)malloc(sizeof(Node));   //申请新的结点
        p->data = x;                     //结点数据域赋值
        r->next = p;                 //将结点插入到表头L-->|1|-->|2|-->NULL
        r = p;
    }
    r->next = NULL;
    return L;
}
 
 
//单链表的插入，在链表的第i个位置插入x的元素
LinkedList LinkedListInsert(LinkedList L,int i,int x) {
    Node *pre;                      //pre为前驱结点
    pre = L;
    int tempi = 0;
    for (tempi = 1; tempi < i; tempi++) {
        pre = pre->next;                 //查找第i个位置的前驱结点
    }
    Node *p;                                //插入的结点为p
    p = (Node *)malloc(sizeof(Node));
    p->data = x;
    p->next = pre->next;
    pre->next = p;
 
    return L;
}
 
 
//单链表的删除，在链表中删除值为x的元素
LinkedList LinkedListDelete(LinkedList L,int x) {
    Node *p,*pre;                   //pre为前驱结点，p为查找的结点。
    p = L->next;
     
    while(p->data != x) {              //查找值为x的元素
        pre = p;
        p = p->next;
    }
    pre->next = p->next;          //删除操作，将其前驱next指向其后继。
    free(p);
     
    return L;
}
 
//链表内容的修改，再链表中修改值为x的元素变为为k。
LinkedList LinkedListReplace(LinkedList L,int x,int k) {
    Node *p=L->next;
    int i=0;
    while(p){
        if(p->data==x){
            p->data=k;
        }
        p=p->next;
    }
    return L;
}
 
 
//便利输出单链表
void printList(LinkedList L){
    Node *p=L->next;
    int i=0;
    while(p){
        printf("第%d个元素的值为:%d\n",++i,p->data);
        p=p->next;
    }
} 
 
int main() {
    //创建 
    LinkedList list;
    printf("请输入单链表的数据：以EOF结尾\n");
    //list = LinkedListCreatH();
    list=LinkedListCreatT();
    printList(list);
     
    //插入 
    int i;
    int x;
    printf("请输入插入数据的位置：");
    scanf("%d",&i);
    printf("请输入插入数据的值：");
    scanf("%d",&x);
    LinkedListInsert(list,i,x);
    printList(list);
     
    //修改
    printf("请输入修改的数据：");
    scanf("%d",&i);
    printf("请输入修改后的值：");
    scanf("%d",&x);
    LinkedListReplace(list,i,x);
    printList(list);
     
    //删除 
    printf("请输入要删除的元素的值：");
    scanf("%d",&x);
    LinkedListDelete(list,x);
    printList(list);
 
    return 0;
}