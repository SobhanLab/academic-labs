from math import fabs

def f(x):
    return x*x*x - 2*x - 5

def secant(f, x0, x1, max_iter=500, eps=0.005):
    iteration = 1
    
    while True:
        f0 = f(x0)
        f1 = f(x1)

        if f1 - f0 == 0:   # Prevent division by zero
            print("Denominator became zero. Try different initial guesses.")
            return None

        # Secant formula
        x2 = x1 - f1 * (x1 - x0) / (f1 - f0)
        ae = fabs(x2 - x1)

        # Update guesses
        x0 = x1
        x1 = x2
        iteration += 1

        if ae <= eps or iteration > max_iter:
            break
    return x1

# Initial guesses
x0 = 2
x1 = 3

xr = secant(f, x0, x1)

if xr is not None:
    print(f"root is at {xr:.4f}")
    print(f"f(xr) = {f(xr):.6f}")
