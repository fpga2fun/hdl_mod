#include <stdio.h>
#include <stdlib.h>
//栈的结点设计
//单个结点设计，数据和下一个指针
typedef struct node     
{
    int data; 
    struct node *next;
} Node;
//利用上面的结点创建栈，分为指向头结点的top指针和计数用的count
typedef struct stack    
{
    Node *top;
    int count;
} Link_Stack;
 
//创建栈
Link_Stack *Creat_stack()
{
    Link_Stack *p;
    //p = new Link_Stack;
    p=(Link_Stack*)malloc(sizeof(Link_Stack));
    if(p==NULL){
        printf("创建失败，即将退出程序");
        exit(0);
    }
    p->count = 0;
    p->top = NULL;
    return p;
}
 
//入栈 push
Link_Stack *Push_stack(Link_Stack *p, int elem)
{
    if (p == NULL)
        return NULL;
    Node *temp;
    temp=(Node*)malloc(sizeof(Node));
    //temp = new Node;
    temp->data = elem;
    temp->next = p->top;
    p->top = temp;
    p->count++;
    return p;
}
 
//出栈 pop
Link_Stack *Pop_stack(Link_Stack *p)
{
    Node *temp;
    temp = p->top;
    if (p->top == NULL)
    {
        printf("错误：栈为空");
        return p;
    }
    else
    {
        p->top = p->top->next;
        free(temp);
        //delete temp;
        p->count--;
        return p;
    }
}
 
//遍历栈：输出栈中所有元素
int show_stack(Link_Stack *p)
{
    Node *temp;
    temp = p->top;
    if (p->top == NULL)
    {
        printf("");
        printf("错误：栈为空");
        return 0;
    }
    while (temp != NULL)
    {
        printf("%d\t", temp->data);
        temp = temp->next;
    }
    printf("\n");
    return 0;
}
 
int main()
{ //用主函数测试一下功能
    Link_Stack *p;
    p = Creat_stack();
    int n = 5;
    int input[6] = {10,20,30,40,50,60};
    /////////////以依次入栈的方式创建整个栈//////////////
    for(int i=0;i<n;i++){
        Push_stack(p, input[i]);
    }
    show_stack(p);
    ////////////////////出栈///////////////////////
    Pop_stack(p);
    show_stack(p);
    return 0;
}