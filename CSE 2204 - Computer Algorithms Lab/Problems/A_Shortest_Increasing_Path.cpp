#include <bits/stdc++.h>
using namespace std;

int main() {
    int t; 
    cin >> t;
    while (t--) {
        int x, y;
        cin >> x >> y;

        if (y > x) {
            cout << 2 << "\n";
        } else if (y >= 2 && x - y >= 2) {
            cout << 3 << "\n";
        } else {
            cout << -1 << "\n";
        }
    }
    return 0;
}
