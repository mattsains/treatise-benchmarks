function funtimes
  null p0
  jnullp p0, .not, .is
  .not:
  movc r1, 1
  jmp .end
  .is:
  movc r1, 2
  .end:
  err
ret
