#!/usr/bin/env nim
import strutils, macros, sequtils

# var (a,b,c) = readInts().unpack(3)
macro unpack*(rhs: seq,cnt: static[int]):auto  =
  let t = genSym();result = quote do:(let `t` = `rhs`;())
  for i in 0..<cnt:result[1].add(quote do:`t`[`i`])

template readInt(): int=
  stdin.readLine.parseInt
template readInts(): seq[int]=
  stdin.readLine.split.map(parseInt)
template readMatrix(n:int): seq[seq[int]]=
  (0..<`n`).mapIt(stdin.readLine.split.map(parseInt))

# var (n,m) = readInts().unpack(2)
# var n = readMatrix(3)
# echo n