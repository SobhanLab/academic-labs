n=int(input("Enter number of items: "))
c=float(input("Enter knapsack capacity: "))

it=[]
for i in range(1,n+1):
    w,v=map(float,input(f"Enter weight and value of Item {i}: ").split())
    it.append((w,v))

it=sorted([(w,v,v/w) for w,v in it],key=lambda x:x[2],reverse=True)

w=t=0
for a,b,r in it:
    if w+a<=c:
        w+=a; t+=b
    else:
        t+=r*(c-w); break

print("Maximum value =",t)