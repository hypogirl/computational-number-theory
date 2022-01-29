import hashlib
load("hw1.sage")

def generate_keys(nbits):
    p,q = gordon(nbits),gordon(nbits)
    n = p * q
    n = int(n)
    m = (p - 1) * (q - 1)
    Zm = IntegerModRing(m)
    Zn = IntegerModRing(n)
    e = Zm.random_element()
    while gcd(e,m) != 1:
        e = Zm.random_element()
    d = 1/e
    e = int(e)
    d = int(d)
    return (n,e),d

def encrypt(PrivateKey, PublicKey, m):
    n,e = PublicKey
    c = power_mod(int(m),e,n)
    c = int(c)
    return c, sign(PrivateKey, PublicKey, m), blind_sign(int(m),PublicKey, PrivateKey)

def decrypt(PublicKey, PrivateKey, c):
    n,e = PublicKey
    m = power_mod(c,PrivateKey,n)
    return m, verify(PublicKey, PrivateKey, m)

def sign(PrivateKey, PublicKey, m):
    n,e = PublicKey
    hash_m = hashlib.sha256(bytes(str(m), encoding='utf-8')).hexdigest()
    hash_m = int(hash_m,16)
    return power_mod(hash_m,PrivateKey,n)

def verify(PublicKey, PrivateKey, m):
    n,e = PublicKey
    hash_m = hashlib.sha256(bytes(str(m), encoding='utf-8')).hexdigest()
    hash_m = int(hash_m,16)
    return power_mod(hash_m,e,n)

def blind_sign(m,PublicKey,PrivateKey):
    n,e = PublicKey
    Zn = IntegerModRing(n)
    r = Zn.random_element()
    while gcd(r,n) != 1:
        r = Zn.random_element()
    blind_message = m*pow(r,e)
    s2 = pow(blind_message,PrivateKey)
    signature = s2*(1/r)
    return signature
    
    
def main():
    message = '35365363858524341'
    nbits = 100
    PublicKey, PrivateKey = generate_keys(nbits)
    c, signature, blind_signature = encrypt(PrivateKey, PublicKey, message)
    m_decrypted, verification = decrypt(PublicKey, PrivateKey, c)

    print("Message:",message,"\nPublic Key:",PublicKey,"\nPrivate Key:",PrivateKey)
    print("\nSignature:",signature,"\nVerification:",verification)
    print("Verified signature?", power_mod(signature,PublicKey[1],PublicKey[0]) == power_mod(verification,PrivateKey,PublicKey[0]))
    print("\nBlind signature:",blind_signature)
    print("\nDecrypted message:",m_decrypted)
   
#if __name__ == "__main__":
#    main()