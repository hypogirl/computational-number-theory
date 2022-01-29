load("gordon-method.sage")

def generate_keys(nbits):
    p = int(gordon(nbits))
    q = int(gordon(nbits))
    
    n = p*q
    
    return n,(p,q)

def encrypt_message(PublicKey,message):
    encoded = int(str(message)*2)
    c = int(power_mod(encoded,2,PublicKey))
    return c

def decrypt_message(n,PrivateKey,c):
    p,q = PrivateKey
    mp = int(sqrt(c)) % p
    mq = int(sqrt(c)) % q
    
    x,a,b = xgcd(p,q)     # a*p + b*q = 1
    
    m1 = (a * p * mq + b * q * mp) % n
    m2 = n - m1
    m3 = (a * p * mq - b * q * mp) % n
    m4 = n - m3
    return m1,m2,m3,m4

def main():
    message = int(input("Message (integers only)? "))
    nbits = int(input("Number of bits? "))
    PublicKey,PrivateKey = generate_keys(nbits)
    c = encrypt_message(PublicKey, message)
    m1,m2,m3,m4 = decrypt_message(PublicKey,PrivateKey,c)
    print(f"\nMessage: {message}\nPublic Key: {PublicKey}\nPrivate Key: {PrivateKey}")
    if Integer(str(message)*2).nbits() >= nbits:
        print("\n\nNote: the number of bits of the encrypted message is greater or equal to the number of bits of the keys, which may cause the decryption not to work properly!")
    print("\n\nDecrypted message alternatives:","\n1:",m1,"\n2:",m2,"\n3:",m3,"\n4:",m4)
   
#if __name__ == "__main__":
#    main()