#include<iostream>
#include<list>
using namespace std;
int cmp(const int &a,const int &b){ 
    //简单的自定义降序序列
    return a>b;
}
int main(){
    list<int> li;           //创建一个空链表
    for(int i=10;i>=6;i--){
        li.push_back(i);
    }
    li.push_front(3);
    li.push_back(20);
    list<int> li2(li);
    for(list<int>::iterator it=li.begin();it!=li.end();it++){
        cout<<*it<<' ';
    }
    cout<<endl;
//排序前3 10 9 8 7 6 20//
    li.sort();
    cout<<"使用sort排序\n"<<' ';
    for(list<int>::iterator it=li.begin();it!=li.end();it++){
        cout<<*it<<' ';
    }
    cout<<endl;
//默认排序后 3 6 7 8 9 10 20//
    li2.sort(cmp);
    for(list<int>::iterator it=li2.begin();it!=li2.end();it++){
        cout<<*it<<' ';
    }
    cout<<endl;
//自定义排序后 20 10 9 8 7 6 3//
    li.sort();
    for(list<int>::iterator it=li.begin();it!=li.end();it++){
        cout<<*it<<' ';
    }
    cout<<endl;
    li.reverse();
     for(list<int>::iterator it=li.begin();it!=li.end();it++){
        cout<<*it<<' ';
    }       
    cout<<endl;
    return 0;
}