import sequtils

type Edmonds* = object
  n: int # 頂点数
  edges: seq[seq[int]]

proc initEdmonds*(n:int): Edmonds = Edmonds(n:n,edges:newseqWith(n,newseq[int](0)))

proc addEdge*(pd:var Edmonds,src,dest:int):void=
  if src == dest: return  
  pd.edges[src].add dest
  pd.edges[dest].add src


proc solve*(ed:var Edmonds):seq[array[2,int]]=
  
  var mu = newSeq[int](ed.n)
  var phi = newSeq[int](ed.n)
  var rho = newSeq[int](ed.n)
  var scanned = newSeqwith(ed.n,false)
  for i in 0..<ed.n:
    (mu[i],phi[i],rho[i]) = (i,i,i)
  var n = ed.n

  proc isRoot(x:int):bool= mu[x] == x
  proc isOuterNonRoot(x:int):bool= mu[x] != x and phi[mu[x]] != mu[x] # 偶点
  proc isOuter(x:int):bool = x.isRoot or x.isOuterNonRoot
  proc isInner(x:int):bool= mu[x] != x and phi[mu[x]] == mu[x] and phi[x] != x
  proc isOutOfForest(x:int):bool= mu[x] != x and phi[mu[x]] == mu[x] and phi[x] == x
  proc vt():seq[int]=
    result = @[]
    for i in 0..<n:
      if i.isRoot:
        result.add 0
      elif i.isOuterNonRoot:
        result.add 2
      elif i.isInner:
        result.add 1
      elif i.isOutOfForest:
        result.add 4
      else:
        result.add -1
  proc nextScan():int=
    for i in 0..<n:
      if scanned[i] == false and i.isOuter:
        return i
    return -1
  proc pathMaximum(vv:int):seq[int] =
    result = @[]
    var v = vv
    while not v.isRoot:
      result.add v
      result.add mu[v]
      v = phi[mu[v]]
    result.add v
  var x = nextScan()
  var y = -1
  while x != -1:
    x = nextScan()
    y = -1

    while y == -1 or ed.edges[x].filter(proc(yy:int):bool=yy.isOutOfForest or rho[yy]!=rho[x]).len > 0:
      y = -1
      for yy in ed.edges[x]:
        if yy.isOutOfForest or (yy.isOuter and rho[yy] != rho[x]):
          y = yy
      if y == -1:
        scanned[x] = true
        break
      # grow
      if y.isOutOfForest:
        phi[y] = x
        continue

      # augment
      let px = pathMaximum(x)
      let py = pathMaximum(y)
      var rs = newseq[int](0)
      for v in px[0..<px.len]:
        if py.contains(v) :
          rs.add v

      
      if rs.len == 0:
        var oddVertexes = newseq[int](0)
        for p in [px,py]:
          for i in 0..<p.len:
            if i mod 2 == 0: continue
            oddVertexes.add p[i]
        for v in oddVertexes:
          (mu[phi[v]], mu[v]) = (v,phi[v])
        (mu[x],mu[y]) = (y,x)
        for i in 0..<ed.n:
          (phi[i],rho[i],scanned[i]) = (i,i,false)
        break
      
      # shrink
      var r = -1
      for re in rs:
        if rho[re] == re:
          r = re
          break
      for p in [px,py]:
        for i in 0..<p.len-1:
          var v = p[i]
          if i mod 2 == 0: continue
          if rho[phi[v]] == r: continue
          phi[phi[v]] = v
          if v == r: break
      if rho[x] != r: phi[x] = y
      if rho[y] != r: phi[y] = x
      for p in [px,py]:
        for i in 0..<p.len-1:
          var v = p[i]
          rho[v] = r
          if v == r: break

    x = nextScan()
  result = newseq[array[2,int]](0)
  for i in 0..<ed.n:
    if mu[i] > i:
      result.add([i,mu[i]])



# var ed = initEdmonds(9)
# ed.addEdge 1,2
# ed.addEdge 2,3
# ed.addEdge 3,4
# ed.addEdge 4,5
# ed.addEdge 5,1
# ed.addEdge 5,6
# ed.addEdge 6,7
# ed.addEdge 7,4
# ed.addEdge 3,8
# ed.addEdge 0,7
# ed.addEdge 0,8



# ed.solve.echo