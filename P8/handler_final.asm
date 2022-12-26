.ktext 0x4180
# get Cause
  mfc0 $t9,$13
# judge if Timer interrupt
  addi $t8,$0,0x0400
  and $t7,$t9,$t8
  beq $t7,$t8,Int_Timer
  nop
# judge if UART interrupt
  addi $t8,$0,0x2000 
  and $t7,$t9,$t8
  beq $t7,$t8,Int_UART
  nop

  Int_Timer:
  and $t3,$s5,$s0 # $s5 = 100
  beq $s5,$t3,Timer_DOWN
  nop
  Timer_UP:
  beq $a0,$t2,END 
  nop
  add $a0,$a0,$s1
  beq $s4,$s2,UART
  nop
  beq $0,$0,END
  nop
  Timer_DOWN:
  beq $a0,$0,END
  nop
  sub $a0,$a0,$s1 # -1
  beq $s4,$s2,UART
  nop
  beq $0,$0,END 
  nop
  UART:
  sw $a0,0x7f30($0)
  beq $0,$0,END
  nop


  Int_UART:
  lb $t6,0x7f33($0)
  sb $t6,0x7f33($0)
  
  END:
  eret
  nop
