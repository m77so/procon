# Wheel factorization
import math
proc getPrimes(n: int): seq[int]=
  result = @[2,3,5]
  const qq =[3,2,1,2,1,2,3,1]
  var bs: seq[bool] = newSeq[bool](n div 2 + 10)
  var sup = (n-3) div 2 
  var i = 2
  var qpos = 1
  while i <= sup:
    if not bs[i]:
      let p = i*2+3
      result.add(p)
      for j in 0..(sup div p):
        if i+j*p <= sup:
          bs[i+j*p] = true
    i += qq[qpos]
    qpos = (qpos + 1) mod len(qq)


proc isPrime(n: int): bool=
  if n == 1 :
    return false
  if n in [2,3,5,7,11]:
    return true
  if n mod 2 == 0 or n mod 3 == 0 or n mod 5 == 0:
    return false
  const qq =[6,3,2,4,2,4,6,2]
  let sup = sqrt(n.toFloat).toInt
  var i = 2
  var qpos = 1
  while i <= sup:
    if n mod i == 0:
      return false
    i += qq[qpos]
    qpos = (qpos + 1) mod len(qq)
  return true