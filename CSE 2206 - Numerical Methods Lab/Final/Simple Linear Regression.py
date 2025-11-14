import numpy as np
import matplotlib.pyplot as plt

x = np.array([1, 2, 3, 4, 5])
y = np.array([0.6, 2.4, 3.5, 4.8, 5.7])
m = len(x)

sum_x = np.sum(x)
sum_y = np.sum(y)
sum_xy = np.sum(x * y)
sum_x2 = np.sum(x * x)

x_mean = sum_x / m
y_mean = sum_y / m

a1 = ((m * sum_xy) - (sum_x * sum_y)) / ((m * sum_x2) - (sum_x ** 2))
a0 = y_mean - (a1 * x_mean)

print(f"Slope (a1): {a1:.2f}")
print(f"Intercept (a0): {a0:.2f}")

y_pred = a0 + a1 * x

plt.scatter(x,y,color = "red", label = "Data points")
plt.plot(x,y_pred, color = "blue", label = "Best_fit line")

plt.legend()
plt.show()