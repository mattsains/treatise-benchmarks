function obtest
  movc r1, 2
  movc r2, 0
  movc r3, 1
  movc r4, 45
  newo p5, r2
  ;p5[0] = p5
  seto p5, r2, r5
  ;p5[1] = 45
  seto p5, r3, r4
  geto r1, p5, r2
  geto r2, p5, r3
  err  
ret