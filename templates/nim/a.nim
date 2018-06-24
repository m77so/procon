#!/usr/bin/env nim
import strutils, macros, sequtils, algorithm,hashes,tables,queues, nre, sets, math, future, typetraits

macro unpack*(rhs: seq,cnt: static[int]):auto  =
  let t = genSym();result = quote do:(let `t` = `rhs`;())
  when NimMajor == 0 and NimMinor < 17:
    for i in 0..<cnt:result[0][1].add(quote do:`t`[`i`])
  else:
    for i in 0..<cnt:result[1].add(quote do:`t`[`i`])

when NimMajor == 0 and NimMinor < 16:
  proc join*[T: not string](a: openArray[T], sep: string = ""): string {.noSideEffect.} =
    result = ""
    for i, x in a:
      if i > 0:
        add(result, sep)
      add(result, $x)

template `max=`*(x,y:typed):void = x = max(x,y)
template `min=`*(x,y:typed):void = x = min(x,y)
template `%=`*(x,y:typed):void = x = x mod y
template `//=`*(x,y:typed):void = x = x div y
template `//`*(x,y:typed):typed = x div y
template readInt(): int=stdin.readLine.parseInt
template readInts(): seq[int]=stdin.readLine.split.map(parseInt)
template readMatrix(n:int): seq[seq[int]]=(0..<`n`).mapIt(stdin.readLine.split.map(parseInt))

macro ll*(x: varargs[untyped]): auto =
  result = newNimNode(nnkStmtList,x)
  for e in x.children:result.add(quote do:(var `e` : int64;))
macro cinLL*(x: varargs[untyped]):auto =
  let t = genSym();var c = 0;result = newNimNode(nnkStmtList,x);
  result.add(quote do:(let `t`=stdin.readLine.split.map(parseBiggestInt)))
  for e in x.children:result.add(quote do:(var `e` : int64 = `t`[`c`]));c.inc

macro cint*(x: varargs[untyped]):auto =
  let t = genSym();var c = 0;result = newNimNode(nnkStmtList,x);
  result.add(quote do:(let `t`=stdin.readLine.split.map(parseInt)))
  for e in x.children:result.add(quote do:(var `e` : int = `t`[`c`]));c.inc
# var (n,m) = readInts.unpack 2