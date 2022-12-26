# 0x7f00-0x7f0b Timer
# 0x7f30-0x7f3f UART
# 0x7f50-0x7f57 DigiitalTube
# 0x7f60-0x7f67 DipSwitch
# 0x7f68-0x7f6b user_key
# 0x7f70-0x7f73 LED

Begin:
# turn on UART interrupt enable
  ori $t0,$0,0x2c01
  mtc0 $t0,$12

# load user_key
  lw $s0,0x7f68($0)
# some const
  addi $s1,$0,0x0001 # 1
  addi $s2,$0,0x0002 # 2
  addi $s3,$0,0x0100 # 2^8
  addi $s5,$0,0x0004 # 4
# judge LED or UART
  and $s4,$s2,$s0
# judge counter or calculator
  and $t0,$s1,$s0
  beq $t0,$s1,counter
  nop

calculator:
  addi $t1,$0,0x0004 # 100
  and $t2,$s0,$t1 
  beq $t2,$t1,ADD  # key[2] == 1
  nop

  mult $t1,$s2 
  mflo $t1 # 1000
  and $t2,$t1,$s0 # key[3] == 1
  beq $t2,$t1,SUB 
  nop

  mult $t1,$s2
  mflo $t1 # 10000
  and $t2,$t1,$s0
  beq $t2,$t1,MULT 
  nop

  mult $t1,$s2
  mflo $t1 # 100000
  and $t2,$t1,$s0
  beq $t2,$t1,DIV
  nop

  mult $t1,$s2
  mflo $t1 # 1000000
  and $t2,$t1,$s0
  beq $t2,$t1,AND 
  nop

  mult $t1,$s2
  mflo $t1
  and $t2,$t1,$s0 # 10000000
  beq $t2,$t1,OR 
  nop

  beq $0,$0,Begin
  nop

  ADD:
  lw $a0,0x7f64($0) # srcA
  lw $a1,0x7f60($0) # srcB
  sw $a2,0x200($0)
  add $a2,$a0,$a1 
  beq $s4,$s2,ADD_UART # key[1] == 1
  nop
  ADD_LED:
  sw $a2,0x7f70($0)
  sw $a2,0x7f50($0)
  beq $0,$0,Begin
  nop
  ADD_UART:
  lw $k0,0x200($0)
  beq $a2,$k0,Begin
  nop
  sw $a2,0x7f30($0)
  beq $0,$0,Begin
  nop

  SUB:
  lw $a0,0x7f64($0) # srcA
  lw $a1,0x7f60($0) # srcB
  sw $a2,0x200($0)
  sub $a2,$a1,$a0 
  beq $s4,$s2,SUB_UART # key[1] == 1
  nop
  SUB_LED:
  sw $a2,0x7f70($0)
  sw $a2,0x7f50($0)
  beq $0,$0,Begin
  nop
  SUB_UART:
  lw $k0,0x200($0)
  beq $a2,$k0,Begin
  nop
  sw $a2,0x7f30($0)
  beq $0,$0,Begin
  nop

  MULT:
  lw $a0,0x7f64($0) # srcA
  lw $a1,0x7f60($0) # srcB
  sw $a2,0x200($0)
  mult $a0,$a1
  mflo $a2  
  beq $s4,$s2,MULT_UART # key[1] == 1
  nop
  MULT_LED:
  sw $a2,0x7f70($0)
  sw $a2,0x7f50($0)
  beq $0,$0,Begin
  nop
  MULT_UART:
  lw $k0,0x200($0)
  beq $a2,$k0,Begin
  nop
  sw $a2,0x7f30($0)
  beq $0,$0,Begin
  nop

  DIV:
  lw $a0,0x7f64($0) # srcA
  lw $a1,0x7f60($0) # srcB
  sw $a2,0x200($0)
  div $a1,$a0
  mflo $a2  
  beq $s4,$s2,DIV_UART # key[1] == 1
  nop
  DIV_LED:
  sw $a2,0x7f70($0)
  sw $a2,0x7f50($0)
  beq $0,$0,Begin
  nop
  DIV_UART:
  lw $k0,0x200($0)
  beq $a2,$k0,Begin
  nop
  sw $a2,0x7f30($0)
  beq $0,$0,Begin
  nop

  AND:
  lw $a0,0x7f64($0) # srcA
  lw $a1,0x7f60($0) # srcB
  sw $a2,0x200($0)
  and $a2,$a0,$a1 
  beq $s4,$s2,AND_UART # key[1] == 1
  nop
  AND_LED:
  sw $a2,0x7f70($0)
  sw $a2,0x7f50($0)
  beq $0,$0,Begin
  nop
  AND_UART:
  lw $k0,0x200($0)
  beq $a2,$k0,Begin
  nop
  sw $a2,0x7f30($0)
  beq $0,$0,Begin
  nop

  OR:
  lw $a0,0x7f64($0) # srcA
  lw $a1,0x7f60($0) # srcB
  sw $a2,0x200($0)
  or $a2,$a0,$a1 
  beq $s4,$s2,OR_UART # key[1] == 1
  nop
  OR_LED:
  sw $a2,0x7f70($0)
  sw $a2,0x7f50($0)
  beq $0,$0,Begin
  nop
  OR_UART:
  lw $k0,0x200($0)
  beq $a2,$k0,Begin
  nop
  sw $a2,0x7f30($0)
  beq $0,$0,Begin
  nop


counter:
# turn on UART&TC interrupt enable
  or $ra,$0,$0 
  ori $t0,0x2c01
  mtc0 $t0,$12
# 1s 
  addi $t1,$0,25000000
# set PRESET reg
  sw $t1,0x7f04($0)
# load init num
  lw $t2,0x7f60($0)
# Timer Ctrl
  ori $s7,$0,11
  sw $s7,0x7f00($0)
# judge UP or DOWN
  and $t3,$s5,$s0 # $s5 = 100
  beq $s5,$t3,DOWN
  nop

  UP:
  add $a0,$0,$0
  beq $s4,$s2,UP_UART
  nop
  UP_LED:
  sw $a0,0x7f50($0)
  sw $a0,0x7f70($0)
# current dipswitch
  lw $t3,0x7f60($0)
# if dipswitch is changed
  bne $t2,$t3,counter
  beq $0,$0,UP_LED
  nop
  UP_UART:
  bne $ra,$0,UP_NEXT
  nop
  addi $ra,$ra,1
  sw $a0,0x7f30($0)
  UP_NEXT:
# current dipswitch
  lw $t3,0x7f60($0)
# if dipswitch is changed
  bne $t2,$t3,counter
  nop
  beq $0,$0,UP_UART
  nop

  DOWN:
  add $a0,$t2,$0
  beq $s4,$s2,DOWN_UART
  nop
  DOWN_LED:
  sw $a0,0x7f50($0)
  sw $a0,0x7f70($0)
# current dipswitch
  lw $t4,0x7f60($0)
# if dipswitch is changed
  bne $t2,$t4,counter
  beq $0,$0,DOWN_LED
  nop
  DOWN_UART:
  bne $ra,$0,DOWN_NEXT
  nop
  addi $ra,$ra,1
  sw $a0,0x7f30($0)
  DOWN_NEXT:
# current dipswitch
  lw $t4,0x7f60($0)
# if dipswitch is changed
  bne $t2,$t4,counter
  nop
  beq $0,$0,DOWN_UART
  nop
