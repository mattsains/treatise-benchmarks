function fasta
  ptr HomoSapiens
  int HomoSapiens_length
  int HomoSapiens_n
  ptr IUB
  int IUB_length
  int IUB_n
  ptr ALU
  int ALU_length
  int ALU_n
  int seed

  movc r0, 4
  setl .HomoSapiens_length, r0
  newo r1, r0
  setl .HomoSapiens, r1
  movc r0, 0
  movc r2, 'a'
  movc r3, 3030
  movc r5, 2
  newo r4, r5
  movc r5, 0
  seto r4, r5, r2
  movc r5, 1
  seto r4, r5, r3
  seto r1, r0, r4
  movc r0, 1
  movc r2, 'c'
  movc r3, 1980
  movc r5, 2
  newo r4, r5
  movc r5, 0
  seto r4, r5, r2
  movc r5, 1
  seto r4, r5, r3
  seto r1, r0, r4
  movc r0, 2
  movc r2, 'g'
  movc r3, 1975
  movc r5, 2
  newo r4, r5
  movc r5, 0
  seto r4, r5, r2
  movc r5, 1
  seto r4, r5, r3
  seto r1, r0, r4
  movc r0, 3
  movc r2, 't'
  movc r3, 3015
  movc r5, 2
  newo r4, r5
  movc r5, 0
  seto r4, r5, r2
  movc r5, 1
  seto r4, r5, r3
  seto r1, r0, r4
  
  movc r0, 15
  setl .IUB_length, r0
  newo r1, r0
  setl .IUB, r1
  movc r0, 0
  movc r2, 'a'
  movc r3, 2700
  movc r5, 2
  newo r4, r5
  movc r5, 0
  seto r4, r5, r2
  movc r5, 1
  seto r4, r5, r3
  seto r1, r0, r4
  movc r0, 1
  movc r2, 'c'
  movc r3, 1200
  movc r5, 2
  newo r4, r5
  movc r5, 0
  seto r4, r5, r2
  movc r5, 1
  seto r4, r5, r3
  seto r1, r0, r4
  movc r0, 2
  movc r2, 'g'
  movc r3, 1200
  movc r5, 2
  newo r4, r5
  movc r5, 0
  seto r4, r5, r2
  movc r5, 1
  seto r4, r5, r3
  seto r1, r0, r4
  movc r0, 3
  movc r2, 't'
  movc r3, 2700
  movc r5, 2
  newo r4, r5
  movc r5, 0
  seto r4, r5, r2
  movc r5, 1
  seto r4, r5, r3
  seto r1, r0, r4
  movc r0, 4
  movc r2, 'B'
  movc r3, 200
  movc r5, 2
  newo r4, r5
  movc r5, 0
  seto r4, r5, r2
  movc r5, 1
  seto r4, r5, r3
  seto r1, r0, r4
  movc r0, 5
  movc r2, 'D'
  movc r3, 200
  movc r5, 2
  newo r4, r5
  movc r5, 0
  seto r4, r5, r2
  movc r5, 1
  seto r4, r5, r3
  seto r1, r0, r4
  movc r0, 6
  movc r2, 'H'
  movc r3, 200
  movc r5, 2
  newo r4, r5
  movc r5, 0
  seto r4, r5, r2
  movc r5, 1
  seto r4, r5, r3
  seto r1, r0, r4
  movc r0, 7
  movc r2, 'K'
  movc r3, 200
  movc r5, 2
  newo r4, r5
  movc r5, 0
  seto r4, r5, r2
  movc r5, 1
  seto r4, r5, r3
  seto r1, r0, r4
  movc r0, 8
  movc r2, 'M'
  movc r3, 200
  movc r5, 2
  newo r4, r5
  movc r5, 0
  seto r4, r5, r2
  movc r5, 1
  seto r4, r5, r3
  seto r1, r0, r4
  movc r0, 9
  movc r2, 'N'
  movc r3, 200
  movc r5, 2
  newo r4, r5
  movc r5, 0
  seto r4, r5, r2
  movc r5, 1
  seto r4, r5, r3
  seto r1, r0, r4
  movc r0, 10
  movc r2, 'R'
  movc r3, 200
  movc r5, 2
  newo r4, r5
  movc r5, 0
  seto r4, r5, r2
  movc r5, 1
  seto r4, r5, r3
  seto r1, r0, r4
  movc r0, 11
  movc r2, 'S'
  movc r3, 200
  movc r5, 2
  newo r4, r5
  movc r5, 0
  seto r4, r5, r2
  movc r5, 1
  seto r4, r5, r3
  seto r1, r0, r4
  movc r0, 12
  movc r2, 'V'
  movc r3, 200
  movc r5, 2
  newo r4, r5
  movc r5, 0
  seto r4, r5, r2
  movc r5, 1
  seto r4, r5, r3
  seto r1, r0, r4
  movc r0, 13
  movc r2, 'W'
  movc r3, 200
  movc r5, 2
  newo r4, r5
  movc r5, 0
  seto r4, r5, r2
  movc r5, 1
  seto r4, r5, r3
  seto r1, r0, r4
  movc r0, 14
  movc r2, 'Y'
  movc r3, 200
  movc r5, 2
  newo r4, r5
  movc r5, 0
  seto r4, r5, r2
  movc r5, 1
  seto r4, r5, r3
  seto r1, r0, r4

  movc r0, 287
  setl .ALU_length, r0
  newb r1, r0
  setl .ALU, r1
  movc r2, 0
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 1
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 2
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 3
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 4
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 5
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 6
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 7
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 8
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 9
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 10
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 11
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 12
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 13
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 14
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 15
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 16
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 17
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 18
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 19
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 20
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 21
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 22
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 23
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 24
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 25
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 26
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 27
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 28
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 29
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 30
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 31
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 32
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 33
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 34
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 35
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 36
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 37
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 38
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 39
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 40
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 41
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 42
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 43
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 44
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 45
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 46
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 47
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 48
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 49
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 50
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 51
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 52
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 53
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 54
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 55
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 56
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 57
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 58
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 59
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 60
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 61
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 62
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 63
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 64
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 65
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 66
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 67
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 68
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 69
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 70
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 71
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 72
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 73
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 74
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 75
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 76
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 77
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 78
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 79
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 80
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 81
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 82
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 83
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 84
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 85
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 86
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 87
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 88
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 89
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 90
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 91
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 92
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 93
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 94
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 95
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 96
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 97
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 98
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 99
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 100
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 101
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 102
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 103
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 104
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 105
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 106
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 107
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 108
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 109
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 110
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 111
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 112
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 113
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 114
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 115
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 116
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 117
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 118
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 119
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 120
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 121
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 122
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 123
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 124
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 125
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 126
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 127
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 128
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 129
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 130
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 131
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 132
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 133
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 134
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 135
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 136
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 137
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 138
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 139
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 140
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 141
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 142
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 143
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 144
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 145
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 146
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 147
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 148
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 149
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 150
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 151
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 152
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 153
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 154
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 155
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 156
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 157
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 158
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 159
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 160
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 161
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 162
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 163
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 164
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 165
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 166
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 167
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 168
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 169
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 170
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 171
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 172
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 173
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 174
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 175
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 176
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 177
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 178
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 179
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 180
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 181
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 182
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 183
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 184
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 185
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 186
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 187
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 188
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 189
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 190
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 191
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 192
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 193
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 194
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 195
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 196
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 197
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 198
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 199
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 200
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 201
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 202
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 203
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 204
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 205
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 206
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 207
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 208
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 209
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 210
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 211
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 212
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 213
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 214
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 215
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 216
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 217
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 218
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 219
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 220
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 221
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 222
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 223
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 224
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 225
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 226
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 227
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 228
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 229
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 230
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 231
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 232
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 233
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 234
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 235
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 236
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 237
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 238
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 239
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 240
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 241
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 242
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 243
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 244
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 245
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 246
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 247
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 248
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 249
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 250
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 251
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 252
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 253
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 254
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 255
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 256
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 257
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 258
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 259
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 260
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 261
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 262
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 263
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 264
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 265
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 266
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 267
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 268
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 269
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 270
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 271
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 272
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 273
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 274
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 275
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 276
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 277
  movc r3, 'G'
  setb r1, r2, r3
  movc r2, 278
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 279
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 280
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 281
  movc r3, 'C'
  setb r1, r2, r3
  movc r2, 282
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 283
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 284
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 285
  movc r3, 'A'
  setb r1, r2, r3
  movc r2, 286
  movc r3, 'A'
  setb r1, r2, r3
  ;phew that was insane

  call makeCumulative, .HomoSapiens, 2
  call makeCumulative, .IUB, 2

  ;">Homosapiens alu"
  movc r0, 22
  newb r1, r0
  movc r2, 0
  movc r3, '>'
  setb r1, r2, r3
  movc r2, 1
  movc r3, 'O'
  setb r1, r2, r3
  movc r2, 2
  movc r3, 'N'
  setb r1, r2, r3
  movc r2, 3
  movc r3, 'E'
  setb r1, r2, r3
  movc r2, 4
  movc r3, 32
  setb r1, r2, r3
  movc r2, 5
  movc r3, 'H'
  setb r1, r2, r3
  movc r2, 6
  movc r3, 'o'
  setb r1, r2, r3
  movc r2, 7
  movc r3, 'm'
  setb r1, r2, r3
  movc r2, 8
  movc r3, 'o'
  setb r1, r2, r3
  movc r2, 9
  movc r3, 32
  setb r1, r2, r3
  movc r2, 10
  movc r3, 's'
  setb r1, r2, r3
  movc r2, 11
  movc r3, 'a'
  setb r1, r2, r3
  movc r2, 12
  movc r3, 'p'
  setb r1, r2, r3
  movc r2, 13
  movc r3, 'i'
  setb r1, r2, r3
  movc r2, 14
  movc r3, 'e'
  setb r1, r2, r3
  movc r2, 15
  movc r3, 'n'
  setb r1, r2, r3
  movc r2, 16
  movc r3, 's'
  setb r1, r2, r3
  movc r2, 17
  movc r3, 32
  setb r1, r2, r3
  movc r2, 18
  movc r3, 'a'
  setb r1, r2, r3
  movc r2, 19
  movc r3, 'l'
  setb r1, r2, r3
  movc r2, 20
  movc r3, 'u'
  setb r1, r2, r3
  movc r2, 21
  movc r3, 0
  setb r1, r2, r3
  print r1

  movc r0, 2000
  setl .ALU_n, r0
  call makeRepeatFasta, .ALU, 3

  ;">TWO IUB ambiguity codes"
  movc r0, 25
  newb r1, r0
  movc r2, 0
  movc r3, '>'
  setb r1, r2, r3
  movc r2, 1
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 2
  movc r3, 'W'
  setb r1, r2, r3
  movc r2, 3
  movc r3, 'O'
  setb r1, r2, r3
  movc r2, 4
  movc r3, 32
  setb r1, r2, r3
  movc r2, 5
  movc r3, 'I'
  setb r1, r2, r3
  movc r2, 6
  movc r3, 'U'
  setb r1, r2, r3
  movc r2, 7
  movc r3, 'B'
  setb r1, r2, r3
  movc r2, 8
  movc r3, 32
  setb r1, r2, r3
  movc r2, 9
  movc r3, 'a'
  setb r1, r2, r3
  movc r2, 10
  movc r3, 'm'
  setb r1, r2, r3
  movc r2, 11
  movc r3, 'b'
  setb r1, r2, r3
  movc r2, 12
  movc r3, 'i'
  setb r1, r2, r3
  movc r2, 13
  movc r3, 'g'
  setb r1, r2, r3
  movc r2, 14
  movc r3, 'u'
  setb r1, r2, r3
  movc r2, 15
  movc r3, 'i'
  setb r1, r2, r3
  movc r2, 16
  movc r3, 't'
  setb r1, r2, r3
  movc r2, 17
  movc r3, 'y'
  setb r1, r2, r3
  movc r2, 18
  movc r3, 32
  setb r1, r2, r3
  movc r2, 19
  movc r3, 'c'
  setb r1, r2, r3
  movc r2, 20
  movc r3, 'o'
  setb r1, r2, r3
  movc r2, 21
  movc r3, 'd'
  setb r1, r2, r3
  movc r2, 22
  movc r3, 'e'
  setb r1, r2, r3
  movc r2, 23
  movc r3, 's'
  setb r1, r2, r3
  movc r2, 24
  movc r3, 0
  setb r1, r2, r3
  print r1
  
  movc r5, 42 ;seed for RNG
  
  movc r0, 3000
  setl .IUB_n, r0
  call makeRandomFasta, .IUB, 3

  movc r0, 30
  newb r1, r0
  ;">THREE Homo sapiens frequency"
  movc r2, 0
  movc r3, '>'
  setb r1, r2, r3
  movc r2, 1
  movc r3, 'T'
  setb r1, r2, r3
  movc r2, 2
  movc r3, 'H'
  setb r1, r2, r3
  movc r2, 3
  movc r3, 'R'
  setb r1, r2, r3
  movc r2, 4
  movc r3, 'E'
  setb r1, r2, r3
  movc r2, 5
  movc r3, 'E'
  setb r1, r2, r3
  movc r2, 6
  movc r3, 32
  setb r1, r2, r3
  movc r2, 7
  movc r3, 'H'
  setb r1, r2, r3
  movc r2, 8
  movc r3, 'o'
  setb r1, r2, r3
  movc r2, 9
  movc r3, 'm'
  setb r1, r2, r3
  movc r2, 10
  movc r3, 'o'
  setb r1, r2, r3
  movc r2, 11
  movc r3, 32
  setb r1, r2, r3
  movc r2, 12
  movc r3, 's'
  setb r1, r2, r3
  movc r2, 13
  movc r3, 'a'
  setb r1, r2, r3
  movc r2, 14
  movc r3, 'p'
  setb r1, r2, r3
  movc r2, 15
  movc r3, 'i'
  setb r1, r2, r3
  movc r2, 16
  movc r3, 'e'
  setb r1, r2, r3
  movc r2, 17
  movc r3, 'n'
  setb r1, r2, r3
  movc r2, 18
  movc r3, 's'
  setb r1, r2, r3
  movc r2, 19
  movc r3, 32
  setb r1, r2, r3
  movc r2, 20
  movc r3, 'f'
  setb r1, r2, r3
  movc r2, 21
  movc r3, 'r'
  setb r1, r2, r3
  movc r2, 22
  movc r3, 'e'
  setb r1, r2, r3
  movc r2, 23
  movc r3, 'q'
  setb r1, r2, r3
  movc r2, 24
  movc r3, 'u'
  setb r1, r2, r3
  movc r2, 25
  movc r3, 'e'
  setb r1, r2, r3
  movc r2, 26
  movc r3, 'n'
  setb r1, r2, r3
  movc r2, 27
  movc r3, 'c'
  setb r1, r2, r3
  movc r2, 28
  movc r3, 'y'
  setb r1, r2, r3
  movc r2, 29
  movc r3, 0
  setb r1, r2, r3
  print r1
  
  movc r0, 5000
  setl .HomoSapiens_n, r0
  call makeRandomFasta, .HomoSapiens, 3
ret

; Important: Preserve r5, it is a global used in this function
function random
  int max

  mulc r5, 3877
  addc r5, 29573
  divc r5, 139968
  mov r5, r0

  getl r1, .max
  mul r1, r5
  divc r1, 139968000000
  mov r0, r1
ret

object Frequency
  int c
  int p

function makeCumulative
  ptr frequencies
  int length

  getl r0, .frequencies
  getl r1, .length


  movc r2, 0 ;total
  movc r3, 0 ;i

  .loop:
  jcmp r3, r1, $, .end, .end
  geto r4, r0, r3
  movc r5, 1
  geto r4, r4, r5
  add r2, r4
  geto r4, r0, r3
  movc r5, 1
  seto r4, r5, r2
  addc r3, 1
  jmp .loop
  .end:
ret

function selectRandom
  ptr frequencies
  int length
  int c_10000000000
  int seedsave

  movc r0, 10000000000
  setl .c_10000000000, r0
  call random, .c_10000000000, 1
  mov r3, r0 ;r3 = r
  getl r0, .frequencies
  getl r1, .length

  movc r2, 0 ;i

  .loop:
  jcmp r2, r1, $, .lend, .lend
  setl .seedsave, r5
  geto r4, r0, r2
  movc r5, 1
  geto r4, r4, r5
  jcmp r3, r4, $, .continue, .continue
  geto r4, r0, r2
  movc r5, 0
  geto r0, r4, r5
  getl r5 .seedsave
  ret
  .continue:
  getl r5 .seedsave
  addc r2, 1
  jmp .loop
  .lend:
  addc r1, -1
  geto r0, r0, r1
  setl .seedsave, r5
  movc r5, 0
  geto r0, r0, r5
  getl r5 .seedsave

ret

function makeRandomFasta
  ptr frequencies
  int length
  int n

  int spill

  movc r0, 1024
  newb r1, r0 ;buffer

  movc r0, 0 ;index

  mov r2, r0 ;m

  getl r3, .n

  .wloop:
  jcmpc r3, 0, .wloopend, .wloopend, $

  jcmpc r3, 60, $, .else, .else
  mov r2, r3
  jmp .ifend
  .else:
  movc r2, 60
  .ifend:

  setl .spill, r3
  movc r4, 0
  .floop:
  jcmp r4, r2, $, .fend, .fend
  mov r3, r0 ;index in r3 temporarily
  call selectRandom, .frequencies, 2
  setb r1, r3, r0
  mov r0, r3
  addc r0, 1
  addc r4, 1
  jmp .floop
  .fend:
  getl r3, .spill

  jcmpc r0, 964, .if2else, $, $
  movc r4, 0
  setb r1, r0, r4
  print r1
  movc r0, 0
  jmp .if2end
  .if2else:

  jcmpc r3, 60, .if2end, .if2end, $
  movc r4, 0xa ;\n
  setb r1, r0, r4
  addc r0, 1
  .if2end:

  addc r3, -60
  jmp .wloop
  
  .wloopend:

  jcmpc r0, 0, $, .end, $
  movc r3, 0
  setb r1, r0, r3
  print r1
  .end:
ret

function makeRepeatFasta
  ptr alu
  int length
  int n

  int spill_k
  int spill_m
  
  movc r0, 1024
  newb r1, r0 ;buffer

  movc r0, 0 ;index
  mov r2, r0 ;m
  getl r3, .n

  setl .spill_k, r0

  .wloop:
  jcmpc r3, 0, .wloopend, .wloopend, $

  jcmpc r3, 60, $, .else, .else
  mov r2, r3
  jmp .ifend
  .else:
  movc r2, 60
  .ifend:

  movc r4, 0
  getl r3, .spill_k
  .forloop:
  jcmp r4, r2, $, .forend, .forend
  setl .spill_m, r2
  getl r2, .length
  jcmp r3, r2, .if2end, $, .if2end
  movc r3, 0
  .if2end:
  getl r2, .alu
  getb r2, r2, r3
  setb r1, r0, r2
  addc r0, 1
  addc r3, 1
  addc r4, 1
  getl r2, .spill_m
  jmp .forloop
  .forend:
  setl .spill_k, r3
  getl r3, .n
  ;setl .spill_alu, r2 ;not needed because it doesn't change
  getl r2, .spill_m
  ; r0 - index
  ; r1 - buffer
  ; r2 - m
  ; r3 - n
  ; r4 - spare

  jcmpc r0, 964, .if3else, $, $
  movc r4, 0
  setb r1, r0, r4
  print r1
  movc r0, 0
  jmp .if3end
  .if3else:

  jcmpc r3, 60, .if3end, .if3else, $
  movc r4, 0xa ;\n
  setb r1, r0, r4
  addc r0, 1
  .if3end:
  
  addc r3, -60
  setl .n, r3
  jmp .wloop

  .wloopend:

  jcmpc r0, 0, $, .end, $
  movc r3, 0
  setb r1, r0, r3
  print r1
  .end:
ret