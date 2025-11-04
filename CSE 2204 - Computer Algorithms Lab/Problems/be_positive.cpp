#include <iostream>
using namespace std;

int main() {
    int t;
    cin >> t;
    while (t--) {
        int n, e;
        cin >> n;
        int result = 0, temp = 0;
        for (int i = 0; i < n; i++)
        {
            cin >> e;
            if (e == 0) result++;
            else if (e == -1) temp++;
        }
        if (temp % 2 == 1)
        {
            result = result + 2;
        }
        cout << result << "\n";
    }
    return 0;
}
