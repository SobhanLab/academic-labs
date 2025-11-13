# --- Trapezoidal rule using table data ---
def trapezoidal_table(x, f):
    n = len(x) - 1  # Number of intervals
    total = f[0] + f[-1]

    for i in range(1, n):
        total += 2 * f[i]

    # Assuming equal spacing
    h = (x[-1] - x[0]) / n
    return (h / 2) * total


# --- Table data ---
x_values = [0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0]          # x-values
f_values = [1, 0.8, 0.5, 0.3077, 0.2, 0.1379, 0.1]      # corresponding f(x)-values

# --- Calculation ---
approx = trapezoidal_table(x_values, f_values)

# --- Output section ---
print(f"Approximate value of the integral: {approx:.5f}")

import math

def func(x):
    # Define the function f(x) = 1 / (1 + x^2)
    return 1 / (1 + x * x)

def trapezoidal_rule(Xo, Xn, n):
    h = (Xn - Xo) / n
    total = func(Xo) + func(Xn)

    for i in range(1, int(n)):
        total += 2 * func(Xo + i * h)

    return (h / 2) * total

# --- Input section ---
Xo = float(input("Enter lower limit (Xo): "))
Xn = float(input("Enter upper limit (Xn): "))
n = int(input("Enter number of intervals (n): "))

# --- Calculation ---
print("=> By using Trapezoidal rule:")
approx = trapezoidal_rule(Xo, Xn, n)

# Exact value using arctangent (tan⁻¹)
exact = math.atan(Xn) - math.atan(Xo)

# Error calculation
error = abs(exact - approx)

# --- Output section ---
print(f"Approximate value of the integral: {approx:.5f}")
print(f"Exact value of the integral:        {exact:.5f}")
print(f"Absolute error:                     {error:.4f}")