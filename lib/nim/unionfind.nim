import sequtils
type UnionFind* = object
  data: seq[int]
  size: int
proc newUnionFind(size: int) : UnionFind =
  UnionFind(data: newSeqWith(size,-1), size: 0)
proc root(uf: var UnionFind, x: int): int =
  if uf.data[x] < 0 :
    result = x
  else:  
    uf.data[x] = uf.root(uf.data[x])
    result = uf.data[x]
proc union(uf: var UnionFind, x: var int, y: var int) : bool =
  x = uf.root(x)
  y = uf.root(y)
  if x != y:
    if uf.data[y] < uf.data[x]:
      (y,x) = (x,y)
    uf.data[x] += uf.data[y]
    uf.data[y] = x
  x != y
proc size(uf: var UnionFind, x: int): int =
  -(uf.data[uf.root(x)])

# var uf = newUnionFind(n+1)
# for i in 1..m:
#   var (x,y) = readInts.unpack 2
#   var a =  uf.union(x,y)