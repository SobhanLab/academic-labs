a = input("Enter first word: ")
b = input("Enter second word: ")

m, n = len(a), len(b)
dp = [[0]*(n+1) for _ in range(m+1)]

for i in range(m):
    for j in range(n):
        dp[i+1][j+1] = dp[i][j] + 1 if a[i]==b[j] else max(dp[i][j+1], dp[i+1][j])

# print DP table
for row in dp:
    print(row)

print("LCS length:", dp[m][n])