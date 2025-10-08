.text
.globl __start
__start:
li $s1, 11 # vector size
la $s0, iArray
li $t0,0 # acumulador
li $t2,0 # contador
li $t3,0
loop: # bucle
add $t4,$s0,$t3 # $t4 = A($s0)
lw $t1, 0($t4)
add $t0,$t0,$t1 # t0 = t0 + t1
addi $t2,$t2,1 # t2++
add $t3,$0,$t2
add $t3,$t3,$t3 # t3 = 2t2
add $t3,$t3,$t3 # t3 = 4t2
beq $t2,$s1,endLoop
j loop
endLoop:
mtc1 $t0,$f8 # f8 <- ($t0) (aun es entero)
mtc1 $s1,$f9 # $f9 <- tamanho (aun es entero)
cvt.s.w $f8,$f8 # conv. ($f8) a p.flotante
cvt.s.w $f9,$f9 # tamanho a p. flotante
div.s $f12,$f8,$f9 # acumulado / tamanho
la $a0, prmp01
li $v0, 4 # print string
syscall
li $v0, 2 # print float
syscall
li $v0, 10 # finish
syscall
.data
iArray: .word 1,2,3,4,5,6,7,8,9,10,11
prmp01: .asciiz "El promedio de los valores es: "