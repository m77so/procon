type CombinationObj = object of RootObj
  fact: seq[int64]
  factinv: seq[int64]
  m: int64
  threshold: int
proc extend_euclid(x0:int64;y0:int64): array[3,int64]=
  var a0,a1,a2,b0,b1,b2,r0,r1,r2,q,x,y:int64
  (x,y)=(x0,y0);r0=x; r1=y; a0=1; a1=0; b0=0; b1=1;
  while r1>0:
    q=r0 div r1; r2=r0 mod r1; a2=a0-q*a1; b2=b0-q*b1; r0=r1; r1=r2; a0=a1; a1=a2; b0=b1; b1=b2;
  result = [a0,b0,r0]
proc mpow(a:int64;b:int64;m:int64=high(1'i64)): int64=
  result = 1
  var (x,n) = (a,b)
  while n!=0:
    if (n and 1) == 1:result = (result*x) mod m
    x = (x*x) mod m;n = n shr 1
proc combination(m: int64 = 1_000_000_007, threshold: int=1_000_000): CombinationObj=
  result = CombinationObj()
  result.m = m
  result.threshold = threshold
  result.fact =  newSeq[int64](threshold+2)
  result.factinv =  newSeq[int64](threshold+2)
  result.fact[0]=1
  for i in 1..threshold+1:
    result.fact[i] = result.fact[i-1]*i mod m
  var a = (extend_euclid(result.fact[threshold+1],m))[0]
  if a<m:a+=m
  result.factinv[threshold+1] = a mod m
  var i = threshold
  while i>=0:
    result.factinv[i] = result.factinv[i+1]*(i+1) mod m
    i-=1
proc C(obj: CombinationObj,n: int,k:int): int64=
  if k < 0 or k > n:
    return 0
  (obj.fact[n] * obj.factinv[k] mod obj.m) * obj.factinv[n-k] mod obj.m
proc P(obj: CombinationObj,n: int,k:int): int64=
  if k > n:
    return 0
  (obj.fact[n] * obj.factinv[n-k]) mod obj.m
proc H(obj: CombinationObj,n: int,k:int): int64=
  if n==0 and k==0:
    return 1
  if n==0:
    return 0
  obj.C(n+k-1,k)


# let c = combination()
# echo c.C(30,3)
