a = input("Enter first word: ")
b = input("Enter second word: ")

m, n = len(a), len(b)
lcs = ""
pos = 0

for i in range(m):
    for j in range(pos, n):
        if a[i] == b[j]:
            lcs += a[i]
            pos = j + 1
            break

print("The lcs is:", lcs)
print("Length of lcs is:", len(lcs))