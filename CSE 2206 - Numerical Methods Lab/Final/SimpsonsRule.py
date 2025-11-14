def simpson_table(x, f):
    n = len(x) - 1
    if n % 2 != 0:
        raise ValueError("Requires even number of intervals.")

    h = (x[-1] - x[0]) / n

    total = f[0] + f[-1]

    for i in range(1, n):
        if i % 2 == 0:
            total += 2 * f[i]
        else:
            total += 4 * f[i]

    return (h / 3) * total


x_values = [0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0]
f_values = [1, 0.8, 0.5, 0.3077, 0.2, 0.1379, 0.1]

approx = simpson_table(x_values, f_values)

print(f"Approximate value of the integral (Simpson's 1/3 Rule): {approx:.5f}")

import math

def func(x):
    return 1 / (1 + x * x)

def simpson_rule(Xo, Xn, n):
    h = (Xn - Xo) / n

    total = func(Xo) + func(Xn)

    for i in range(1, int(n)):
        if i % 2 == 0:
            total += 2 * func(Xo + i * h)
        else:
            total += 4 * func(Xo + i * h)

    return (h / 3) * total


# --- Input section ---
Xo = float(input("Enter lower limit (Xo): "))
Xn = float(input("Enter upper limit (Xn): "))
n = int(input("Enter number of intervals: "))

if n % 2 != 0:
    print("Number of intervals (n) must be even for Simpson's rule.")
else:
    print("=> By using Simpson rule:")
    approx = simpson_rule(Xo, Xn, n)

    exact = math.atan(Xn) - math.atan(Xo)

    error = abs(exact - approx)

    print(f"Approximate value of the integral: {approx:.5f}")
    print(f"Exact value of the integral:        {exact:.5f}")
    print(f"Absolute error:                     {error:.5f}")