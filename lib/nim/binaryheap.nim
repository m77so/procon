# binary heap https://github.com/bluenote10/nim-heap MIT LICENSE https://github.com/bluenote10/nim-heap/blob/master/LICENSE
import strutils
proc parentInd(i: int): int {.inline.} = (i-1) div 2
proc childLInd(i: int): int {.inline.} = 2*i + 1
proc childRInd(i: int): int {.inline.} = 2*i + 2
type
  Heap*[T] = object
    data: seq[T]
    size: int
    comp: proc (x: T, y: T): int 
  EmptyHeapError* = object of Exception
proc size*[T](h: Heap[T]): int {.inline.} = h.size
proc hasChildAt[T](h: Heap[T], i: int): bool {.inline.} =i < h.size
proc hasParentAt[T](h: Heap[T], i: int): bool {.inline.} =0 <= i
proc indicesWithChildren*[T](h: Heap[T]): Slice[int] {.inline.} =
  let lastIndexWithChildren = (h.size div 2) - 1
  0 .. lastIndexWithChildren
proc propFulfilled[T](h: Heap[T], indParent, indChild: int): bool {.inline.} = h.comp(h.data[indParent], h.data[indChild]) <= 0
template assertHeapProperty[T](h: Heap[T], enabled: expr = true) =
  when enabled:
    for i in h.indicesWithChildren:
      let j = childLInd(i)
      let k = childRInd(i)
      if not h.propFulfilled(i, j):
        raise newException(AssertionError, format(
          "Propertiy not fulfilled for $#, $# values $#, $#",
          i, j, h.data[i], h.data[j]
        ))
      if h.hasChildAt(k) and not h.propFulfilled(i, k):
        raise newException(AssertionError, format(
          "Propertiy not fulfilled for $#, $# values $#, $#",
          i, k, h.data[i], h.data[k]
        ))
proc swap[T](h: var Heap[T], i, j: int) {.inline.} =
  let t = h.data[j]
  h.data[j] = h.data[i];h.data[i] = t
proc siftup[T](h: var Heap[T], i: int) =
  let j = i.parentInd
  if h.hasParentAt(j) and not h.propFulfilled(j,i):h.swap(i,j);h.siftup(j)
proc siftdown[T](h: var Heap[T], i: int) =
  let j = i.childLInd
  let k = i.childRInd
  if h.hasChildAt(j) and h.hasChildAt(k):
    if not h.propFulfilled(i,j) or not h.propFulfilled(i,k):
      if h.propFulfilled(j,k):h.swap(i,j);h.siftdown(j)else:h.swap(i,k);h.siftdown(k)
  elif h.hasChildAt(j):
    if not h.propFulfilled(i,j):h.swap(i,j);h.siftdown(j)
proc newHeap*[T](comparator: proc (x: T, y: T): int): Heap[T] =
  Heap[T](data: newSeq[T](), size: 0, comp: comparator)
proc newHeapFromArray*[T](arr: openarray[T], comparator: proc (x: T, y: T): int = system.cmp): Heap[T] =
  var h = Heap[T](data: newSeq[T](arr.len), size: arr.len, comp: comparator)
  for i, x in arr:h.data[i] = x
  let indicesWithChildren = h.indicesWithChildren
  for i in countdown(indicesWithChildren.b, indicesWithChildren.a):h.siftdown(i)
  result = h
proc peek*[T](h: Heap[T]): T = h.data[0]
proc push*[T](h: var Heap[T], x: T) = h.data.add(x);h.siftup(h.size);h.size.inc;h.assertHeapProperty(defined(debugHeaps))
proc pop*[T](h: var Heap[T]): T =
  if not h.size > 0:
    raise newException(EmptyHeapError, "cannot pop element, heap is empty")
  result = h.data[0];h.data[0] = h.data[^1];h.size.dec;h.data.setlen(h.size);h.siftdown(0);h.assertHeapProperty(defined(debugHeaps))
proc pushPop*[T](h: var Heap[T], x: T): (bool, T) =
  if h.size == 0:
    return (false, x)
  elif h.comp(x, h.data[0]) <= 0: # cannot call propFulfilled, since x has no index yet
    return (false, x)
  else:result = (true, h.data[0]);h.data[0] = x;h.siftdown(0)
proc popPush*[T](h: var Heap[T], x: T): T =
  if not h.size > 0:
    raise newException(EmptyHeapError, "cannot pop element, heap is empty")
  result = h.data[0];h.data[0] = x;h.siftdown(0)
iterator items*[T](h: Heap[T]): T =
  for x in h.data:yield x
iterator sortedItems*[T](h: Heap[T]): T =
  var tmp = h
  while tmp.size > 0:
    let x = tmp.pop
    yield x



# import math
# import algorithm
# import sequtils
# var h = newHeap[int](system.cmp)
# for i in 1..100:
#   h.push( i*913 mod 233)
#   echo  i*913 mod 233
# echo h
# for i in 1..12:
#   echo h.pop
