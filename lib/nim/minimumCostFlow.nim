import sequtils
#include binaryheap

type Edge[T] = object
  src: int
  dest: int
  capacity: T
  cost: T
  flowing: T
  counterIndex: int
  rev: bool

type PrimalDual[T] = object
  n: int # 頂点数
  edges: seq[seq[Edge[T]]]

proc initPrimalDual[T](n:int): PrimalDual[T] = PrimalDual[T](n:n,edges:newseqWith(n,newseq[Edge[T]](0)))

proc addEdge[T](pd:var PrimalDual,src,dest:int,capacity,cost:T):void=
  if src == dest: return  
  pd.edges[src].add Edge[T](src:src,dest:dest,cost:cost,capacity:capacity,counterIndex:pd.edges[dest].len,rev:false)
  pd.edges[dest].add Edge[T](src:dest,dest:src,cost: -cost,counterIndex:pd.edges[src].len - 1,rev:true)



proc solve[T](pd:var PrimalDual[T],start,goal:int,amount:T): T=
  var potential = newseqwith(pd.n,0)
  var costs = newseqwith(pd.n,T.high)
  type CostPair = tuple
    node: int
    cost: T
  var f = amount
  var q = newHeap[CostPair](proc(a,b:CostPair):int=system.cmp(a.cost,b.cost))
  var prevNode = newseqwith(pd.n,-1)
  var prevEdgeIndex = newseqwith(pd.n,-1)
  while f > 0 :

    var subCosts = newseqwith(pd.n,T.high)
    subCosts[start] = 0
    q.push((start,0))
    while q.size > 0:
      let s = q.pop
      if subCosts[s.node] < s.cost: continue
      for nextEdgeIndex in 0..<pd.edges[s.node].len:
        let nextEdge = pd.edges[s.node][nextEdgeIndex]
        let nextCost = subCosts[s.node] + nextEdge.cost - potential[nextEdge.src] + potential[nextEdge.dest]
        if nextEdge.capacity>0 and nextCost < subCosts[nextEdge.dest]:
          subCosts[nextEdge.dest] = nextCost
          prevNode[nextEdge.dest] = nextEdge.src
          prevEdgeIndex[nextEdge.dest] = nextEdgeIndex
          q.push((nextEdge.dest,nextCost))
    if subCosts[goal] == T.high: return -1
    for i in 0..<pd.n:
      potential[i] = potential[i] - subCosts[i]
    
    var addF = f
    var needle = goal
    while needle != start:
      addF = min(addF,pd.edges[prevNode[needle]][prevEdgeIndex[needle]].capacity)
      needle = prevNode[needle]
    result -= potential[goal] * addF
    needle = goal
    while needle != start:
      let ci = pd.edges[prevNode[needle]][prevEdgeIndex[needle]].counterIndex
      let cs = pd.edges[prevNode[needle]][prevEdgeIndex[needle]].dest
      pd.edges[prevNode[needle]][prevEdgeIndex[needle]].capacity -= addF
      pd.edges[cs][ci].capacity += addF
      needle = prevNode[needle]
    f -= addF
type PrimalDualResponse[T] = tuple
  src: int
  dest: int
  flow: T
  capacity: T

proc getSolvedFlow[T](pd:PrimalDual[T]): seq[PrimalDualResponse[T]] =
  result = newseq[PrimalDualResponse[T]]()
  for es in pd.edges:
    for e in es:
      if e.rev == false : result.add((src:e.src,dest:e.dest,flow:pd.edges[e.dest][e.counterIndex].capacity,capacity:e.capacity+pd.edges[e.dest][e.counterIndex].capacity))




# var pd = initPrimalDual[int](6)
# pd.addEdge 0,1,2,2
# pd.addEdge 0,3,7,4
# pd.addEdge 1,2,4,6
# pd.addEdge 1,3,2,1
# pd.addEdge 2,5,7,2
# pd.addEdge 3,2,1,6
# pd.addEdge 3,4,6,2
# pd.addEdge 4,2,3,2
# pd.addEdge 4,5,2,7

# pd.solve(0,5,4).echo
# pd.getSolvedFlow.echo