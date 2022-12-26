# 0x7f00-0x7f0b Timer
# 0x7f30-0x7f3f UART
# 0x7f50-0x7f57 DigiitalTube
# 0x7f60-0x7f67 DipSwitch
# 0x7f68-0x7f6b user_key
# 0x7f70-0x7f73 LED

# last_op
or $s2,$0,$0

Loop:
lb $s0,0x7f33($0)
ori $s1,$0,'C'
beq $s1,$s0,END
nop

# load user_key
lw $s0,0x7f68($0)
# if op == last_op
beq $s0,$s2,Calculate
nop

# last_op != op
or $s2,$s0,$0
# load num
lw $a0,0x7f60($0) # num1
lw $a1,0x7f64($0) # num2
beq $0,$0,Loop
nop

Calculate:
beq $a0,$0,Loop
nop

ori $t0,$0,0x0001
beq $s0,$t0,ADD
nop

ori $t0,$0,0x0002
beq $s0,$t0,SUB
nop

ori $t0,$0,0x0004
beq $s0,$t0,MULT
nop

ori $t0,$0,0x0008
beq $s0,$t0,DIV
nop

# else num1 = 0
or $a0,$0,$0
beq $0,$0,Loop
nop

ADD:
add $a0,$a0,$a1
beq $0,$0,Print
nop

SUB:
sub $a0,$a0,$a1
beq $0,$0,Print
nop

MULT:
mult $a0,$a1
mflo $a0
beq $0,$0,Print
nop

DIV:
bne $a1,$0,true_div
nop
or $a0,$0,$0
beq $0,$0,Print
nop

true_div:
div $a0,$a1
mflo $a0
beq $0,$0,Print
nop

Print:
ori $t0,$0,0x0001
and $a2,$a0,$t0
bne $a2,$0,DT_print
nop

UART_Print:
sw $a0,0x7f30($0)
sw $0,0x7f50($0)
beq $0,$0,Print_end_1
nop

DT_print:
sw $a0,0x7f50($0)
beq $0,$0,Print_end_1
nop

Print_end_1:
or $s6,$0,$0
Print_end:
# turn on UART&TC interrupt enable
  ori $t0,0x2c01
  mtc0 $t0,$12
# 1s 
  addi $t1,$0,25000000
# set PRESET reg
  sw $t1,0x7f04($0)
# load init num
  or $t2,$0,10000
  lw $t2,0x7f60($0)
# Timer Ctrl
  ori $s7,$0,11
  sw $s7,0x7f00($0)
  wait:
  beq $s6,$0,wait
  nop
  beq $0,$0,Calculate
  nop




END:
lui $s0,0x2137
ori $s0,$s0,0x3293
sw $s0,0x7f50($0)
sw $s0,0x7f70($0)
beq $0,$0,END
nop
