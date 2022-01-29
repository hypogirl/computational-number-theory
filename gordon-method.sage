import math
logs = list()

def is_strong_prime(n):
    i = n
    j = n
    while True:
        i+=1
        if is_prime(i):
            break
    while True:
        j-=1
        if is_prime(j):
            break
    return n > (i+j)/2

def gordon(nbits):
    #1
    s = 0
    t = 64
    while (s.nbits() <= t.nbits()):
        s = random_prime(int(pow(2,math.floor(nbits/2))))
        t = random_prime(int(pow(2,math.floor(nbits/2-1))))
    #2
    i = 0
    while True:
        r = 2*i*t + 1
        if is_prime(r):
            break
        i += 1
    #3
    p0 = 2*int(pow(s,r-2,r))*s - 1
    #4
    j = 0
    while True:
        p = p0 + 2*j*r*s
        if is_prime(p):
            break
        j += 1
    #5
    logs.append([(s,s.nbits()),(t,t.nbits()),(r,r.nbits()),(p,p.nbits(), is_strong_prime(p))])
    if not(is_strong_prime(p)):
        return gordon(nbits)
    return p

def log_print():
    i = 0
    for entry in logs:
        i+=1
        log_str = f"""Iteration {str(i)}:
            s = {entry[0][0]}; bits = {entry[0][1]}
            t = {entry[1][0]}; bits = {entry[1][1]}
            r = {entry[2][0]}; bits = {entry[2][1]}
            prime_number = {entry[3][0]}; bits = {entry[3][1]}; strong prime? {entry[3][2]}
        """
        print(log_str)

def main(bits):
    if nbits <= 3:
        print("\nnbits needs to be greater than 3.")
        return
    print("\nstrong_prime =",gordon(nbits),"\n\n")
    return log_print()

#if __name__ == "__main__":
#    nbits = int(input("Number of bits?"))
#    main(nbits)