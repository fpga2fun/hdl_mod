#include <iostream>
#include <string>
#include <map>
using namespace std;
int *getWay(int n){
    int *p=new int[3];
    p[0]=n+10;
    p[1]=n+20;
    p[2]=n+30;
    return p;
} 
struct ans
{
    /* data */
    int  a;
    char b;
    double c;
};
ans getway (int n){
    struct ans r_ans;
        /* data */
        r_ans.a=n;
        r_ans.b=n+10;
        r_ans.c=n+0.01;
        return r_ans;
    
}
int main(){
    multimap<string, int> m_map;
    string name="XiaoMing";
    m_map.insert(make_pair(name, 50));
    m_map.insert(make_pair(name, 55));
    m_map.insert(make_pair(name, 60));
    //方式1
    cout<<"----------方法1-----------"<<endl;
    int k;
    multimap<string, int>::iterator m;
    m = m_map.find(name);
    for (k = 0; k != m_map.count(name); k++, m++)
        cout << m->first << "--" << m->second << endl;
    //方式2
    cout<<"----------方法2-----------"<<endl;
    multimap<string, int>::iterator beg, end;
    beg = m_map.lower_bound(name);
    end = m_map.upper_bound(name);
    for (m = beg; m != end; m++)
        cout << m->first << "--" << m->second << endl;
    //方式3
    cout<<"----------方法3-----------"<<endl;
    beg = m_map.equal_range(name).first;
    end = m_map.equal_range(name).second;
    for (m = beg; m != end; m++)
        cout << m->first << "--" << m->second << endl;
    // -----------------------------------//
    int *res = getWay(10);
    for(int i=0;i<3;i++){
        cout<<res[i]<<' '<<endl;
    }
    delete []res;//防止内存泄漏
    ans ans = getway(11);
    cout<<ans.a<<' '<<ans.b<<' '<<ans.c<<endl;

    return 0;
}