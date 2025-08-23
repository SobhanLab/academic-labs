def f(x):
    return 0.5*x*x*x - x*x

def FalsePosition(f, xl, xu, max_itr=300, eps=0.05):
    if f(xl) * f(xu) > 0:
        print("Wrong guess!")
        return None
    
    if f(xl) * f(xu) == 0:
        if f(xl) == 0:
            return xl
        else:
            return xu

    itr = 1
    xr_old = xl
    while True:
        xr_new = xu - (f(xu) * (xl - xu)) / (f(xl) - f(xu))
        ae = abs(xr_new - xr_old)
        xr_old = xr_new
        
        if f(xl) * f(xr_new) < 0:
            xu = xr_new
        elif f(xl) * f(xr_new) > 0:
            xl = xr_new
        else:
            return xr_new
        
        itr += 1
        if ae <= eps or itr > max_itr:
            break

    return xr_old

xl, xu = 1, 3
xr = FalsePosition(f, xl, xu)

if xr is not None:
    print(f"The root of this function: {xr:.3f}")
    print(f"The value of the function at xr: f(xr) = {f(xr):.3f}")
