import math

def f(x):
    return x * math.exp(x) - 1

def f_prime(x):
    return math.exp(x) * (x + 1)

def newton_raphson(x0, tol=1e-6, max_iter=20):
    print("Newton-Raphson Method for f(x) = x*e^x - 1")
    print("Initial guess: ", x0)
    
    for i in range(max_iter):
        fx = f(x0)
        fpx = f_prime(x0)
        
        if fpx == 0:
            print("Error: Derivative is zero. Method fails.")
            return None
        
        x1 = x0 - fx / fpx
        print(f"Iteration {i+1}: x = {x1:.6f}, f(x) = {fx:.6f}")
        
        if abs(x1 - x0) < tol:
            print("\nRoot found: ", round(x1, 6))
            return x1
        
        x0 = x1
    
    print("\nDid not converge within given iterations.")
    return None

x0 = float(input("Enter the initial guess: "))
newton_raphson(x0)