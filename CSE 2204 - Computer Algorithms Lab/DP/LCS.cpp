#include <bits/stdc++.h>
using namespace std;

void lcsAlgo(char *s1, char *s2, int m, int n)
{
    int lcsTable[m+1][n+1];

    for (int i = 0; i <= m; i++) {
        for (int j = 0; j <= n; j++) {
            if (i == 0 || j == 0) {
                lcsTable[i][j] = 0;
            } else if (s1[i-1] == s2[j-1]) {
                lcsTable[i][j] = lcsTable[i-1][j-1] + 1;
            } else {
                lcsTable[i][j] = max(lcsTable[i-1][j], lcsTable[i][j-1]);
            }
        }
    }

    int lcs_length = lcsTable[m][n];
    char lcs[lcs_length + 1];
    int idx = lcs_length;
    lcs[idx] = '\0';

    int i = m, j = n;
    while (i > 0 && j > 0) {
        if (s1[i-1] == s2[j-1]) {
            lcs[idx - 1] = s1[i-1];
            i--; j--; idx--;
        } else if (lcsTable[i-1][j] > lcsTable[i][j-1]) {
            i--;
        } else {
            j--;
        }
    }

    cout << "The first sequence: " << s1 << endl;
    cout << "The second sequence: " << s2 << endl;
    cout << "The LCS: " << lcs << endl;
    cout << "LCS length: " << lcs_length << endl;
}

int main() {
    int m, n;

    cout << "Length of first sequence: ";
    cin >> m;
    cout << "Enter first sequence: ";
    char s1[m + 1];
    cin >> s1;

    cout << "Length of second sequence: ";
    cin >> n;
    cout << "Enter second sequence: ";
    char s2[n + 1];
    cin >> s2;

    lcsAlgo(s1, s2, m, n);
    return 0;
}
