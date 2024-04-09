#include <iostream>
#include <set>
#include <vector>
#include <algorithm>        //使用算法头文件
using namespace std;
  
int main(){
    set<int> a, b;           //建立两个集合
    vector<int> c;           //建立一个向量，我们用这个向量存储运算结果
    //a = {2,4,6};
    a.insert(2);
    a.insert(4);
    a.insert(6);
    //b = {1,2,3,4,5};
    b.insert(1);
    b.insert(2);
    b.insert(3);
    b.insert(4);
    b.insert(5);
  
    set_union(a.begin(), a.end(), b.begin(), b.end(), back_inserter(c));//并集
    for(vector<int>::iterator it=c.begin();it!=c.end();it++){
        cout<< *it << ' ';
    }
    cout<<endl;
    c.clear();
 
  
  
    set_intersection(a.begin(), a.end(), b.begin(), b.end(), back_inserter(c));//交集
    for(vector<int>::iterator it=c.begin();it!=c.end();it++){
        cout<< *it << ' ';
    }
    cout<<endl;
    c.clear();
  
    set_difference(a.begin(), a.end(), b.begin(), b.end(), back_inserter(c)); //差集 从A中减去B包含的元素
    for(vector<int>::iterator it=c.begin();it!=c.end();it++){
        cout<< *it << ' ';
    }
    cout<<endl;
    c.clear();
  
    return 0;
}