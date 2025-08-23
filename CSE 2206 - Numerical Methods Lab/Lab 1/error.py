measured_value = float(input("Enter the measured value: "))
true_value = float(input("Enter the true value: "))

absolute_error = abs(measured_value - true_value)
relative_error = absolute_error / true_value
percent_relative_error = relative_error * 100

print(f"Absolute Error       = {absolute_error:.4f}")
print(f"Relative Error       = {relative_error:.6f}")
print(f"Percent Relative Error = {percent_relative_error:.2f}%")
