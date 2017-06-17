.text

  .global _start
_start:
// moving data from rom to ram before branch to entry
  ldr r3, VARS
  str r3, [fp, #-4]
  ldr r3, VARS+4
  str r3, [fp, #-8]
  b   _L1
_L2:
  ldr r2, [fp, #-4]
  add r3, r2, #1
  str r3, [fp, #-4]
  ldr r3, [fp, #-8]
  add r1, r3, #1
  str r1, [fp, #-8]
  ldrb    r2, [r2]
  strb    r2, [r3]
_L1:
  ldr r3, [fp, #-8]
  ldr r2, VARS+8
  cmp r3, r2
  bcc _L2
  ldr r3, VARS+12
  str r3, [fp, #-8]
  b   _L3
_L4:
  ldr r3, [fp, #-8]
  mov r2, #0
  strb    r2, [r3]
  ldr r3, [fp, #-8]
  add r3, r3, #1
  str r3, [fp, #-8]
_L3:
  ldr r3, [fp, #-8]
  ldr r2, VARS+16
  cmp r3, r2
  bcc _L4
  b entry  @ Branch to entry()
loop:
  b loop
VARS:
  .word  _erdata
  .word  _data
  .word  _edata
  .word  _bstart
  .word  _bend
