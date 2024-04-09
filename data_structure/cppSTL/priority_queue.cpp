#include <queue>
#include <iostream>
using namespace std;
struct cmp
{ //这个比较要用结构体表示
    bool operator()(int &a, int &b) const
    {
        return a > b;
    }
};
int main()
{
    priority_queue<int, vector<int>, cmp> q;
    for (int i = 1; i <= 5; i++)
    {
        q.push(i * 10);
        cout << "push element " << i << endl;
    }
    q.push(4);
    q.push(15);
    int i = 1;
    while (!q.empty())
    {
        int temp = q.top();
        q.pop();
        cout << "No " << i++ << " element is: " << temp << endl;
    }
    return 0;
}