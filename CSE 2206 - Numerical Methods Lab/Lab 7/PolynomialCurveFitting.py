import numpy as np
import matplotlib.pyplot as plt

# Sample data
x = np.array([1, 2, 3, 4, 5], dtype=float)
y = np.array([2.5, 3.0, 6.3, 12.5, 17.0], dtype=float)

# Degree of polynomial
n = 2  

m = len(x)

#  Step 1: Compute required summations 
Xsum = [np.sum(x**k) for k in range(2*n + 1)]   # Σx^k
Ysum = [np.sum((x**k) * y) for k in range(n + 1)]  # Σx^k * y

#  Step 2: Build normal equation matrix (A) and RHS (B) 
A = np.zeros((n+1, n+1))
B = np.zeros(n+1)

for i in range(n+1):
    for j in range(n+1):
        A[i, j] = Xsum[i + j]
    B[i] = Ysum[i]

#  Step 3: Solve for coefficients
a = np.linalg.solve(A, B)

print("Polynomial coefficients (a0, a1, a2,...):", a)

#  Step 4: Predict values 
y_pred = np.zeros_like(x)
for i in range(n+1):
    y_pred += a[i] * (x ** i)

# Step 5: Plot 
plt.scatter(x, y, label="Data points")
plt.plot(x, y_pred, color='red', label=f"Degree {n} fit")
plt.legend()
plt.show()
