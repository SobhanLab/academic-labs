import pandas as pd

def calculate_x_minus_xi(i, val, x):
    prod = 1
    for j in range(i):
        prod *= (val - x[j])
    return prod

def newton_divided_difference(x, y, val):
    n = len(x)

    table = [[None] * n for _ in range(n)]

    for i in range(n):
        table[i][0] = y[i]

    for j in range(1, n):
        for i in range(n - j):
            table[i][j] = (table[i+1][j - 1] - table[i][j - 1]) / (x[i+j] - x[i])

    col_names = [f"Δ^{i}y" for i in range(n)]

    df = pd.DataFrame(table, columns=col_names)
    df.insert(0, "x", x)

    print("=> By using Newton Divided Difference Interpolation:\n")
    print(df.round(4).fillna(""))

    result = table[0][0]
    for i in range(1, n):
        result += table[0][i] * calculate_x_minus_xi(i, val, x)

    print(f"\nApproximate result at point {val} is: {result:.5f}")
    return None

x = [2.04, 2.28, 2.63, 2.94, 3.18]
y = [0.87291, 0.73942, 0.45837, 0.20153, 0.09712]
val = 2.77

newton_divided_difference(x, y, val)