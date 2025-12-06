n = int(input("Enter number of activities: "))
a = []

for i in range(n):
    s = int(input(f"Start time of activity {i+1}: "))
    f = int(input(f"Finish time of activity {i+1}: "))
    a.append((f, s, i+1))

a.sort()

print("\nSelected activities:")
last = 0
for f, s, idx in a:
    if s >= last:
        print(f"Activity {idx} Start: {s} Finish: {f}")
        last = f