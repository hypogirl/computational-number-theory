import hashlib
load("hw1.sage")

def generate_keys(nbits):
    p = gordon(nbits)
    Zp = IntegerModRing(p)
    Zp_minus_one = IntegerModRing(p-1)
    a = int(Zp.random_element())
    x = Zp_minus_one.random_element()
    while gcd(x,p-1) != 1:
        x = Zp_minus_one.random_element()
    x = int(x)
    c = power_mod(a,x,p)
    return (p,a,c),(p,a,x)

def sign(PrivateKey, m):
    encoded_m = m.encode()
    hash_m = int(hashlib.sha256(encoded_m).hexdigest(),16)
    p,a,x = PrivateKey
    Zp_minus_one = IntegerModRing(p-1)
    k = Zp_minus_one.random_element()
    while gcd(k,p-1) != 1:
        k = Zp_minus_one.random_element()
    k = int(k)
    r = power_mod(a,k,p)
    inverse_k = 1/k
    l = inverse_k % (p - 1)
    s = int(l*(hash_m - r*x) % (p - 1))
    return (r,s), hash_m

def verify(PublicKey,signature,m):
    (p,a,c),(r,s) = PublicKey, signature
    if r >= p or r == 0:
        return False
    v1 = power_mod(c,r,p) * power_mod(r,s,p) % p
    v2 = power_mod(a,m,p)
    return v1 == v2

def main():
    message = '495859058490548350'
    nbits = 300
    if nbits < 256:
        print("Warning: Number of bits should be greater than 256.\n")
    PublicKey,PrivateKey = generate_keys(nbits)
    signature,hash_m = sign(PrivateKey,message)
    verification = verify(PublicKey,signature,hash_m)
    print("Original message:", message)
    print("Message's hash:", hash_m)
    print("\nPublic Key:",PublicKey,"\nPrivate Key",PrivateKey)
    print("Signature:",signature)
    print("\nVerified signature?",verification)
   
#if __name__ == "__main__":
#    main()