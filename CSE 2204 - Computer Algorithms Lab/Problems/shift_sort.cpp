#include <bits/stdc++.h>
using namespace std;

int main() {
    int t;
    cin >> t;

    while (t--) {
        int n;
        string s;
        cin >> n;
        cin >> s;

        int count = 0;
        int i;

        for (i = 0; i < n; i++) {
            if (s[i] == '0') {
                count++;
            }
        }

        int wrong_position = 0;

        for (i = 0; i < count; i++) {
            if (s[i] == '1') {
                wrong_position++;
            }
        }

        cout << wrong_position << "\n";
    }

    return 0;
}
