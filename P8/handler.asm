.ktext 0x4180
# get cause
mfc0 $t9,$13
# judge if timer 
addi $t8,$0,0x0400
and $t7,$t9,$t8
bne $t7,$t8,ERET
nop

or $t0,$0,$0
mtc0 $t0,$12

ori $t0,$0,0x0001
add $s6,$s6,$t0

ERET:
eret
nop
