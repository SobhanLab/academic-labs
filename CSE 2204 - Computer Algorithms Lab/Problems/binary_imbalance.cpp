#include <bits/stdc++.h>
using namespace std;

int main() {
    int t; 
    cin >> t;
    while (t--) {
        int n, temp = 0;
        cin >> n;
        char s[n];
        for (int i = 0; i < n; i++) {
            cin >> s[i];
            if (s[i] == '0') {
                temp++;
            }
        }
        if (temp > 0) 
            cout << "Yes" <<endl;
        else 
            cout << "No" << endl;
    }
}
