.data
msg1: .asciiz "Ingrese el grado del polinomio n: "
msg2: .asciiz "Ingrese el coeficiente a"
msg3: .asciiz "Ingrese el valor de x: "
msg4: .asciiz "El resultado del polinomio P(x) es: "
dosPuntos: .asciiz ": "
salto: .asciiz "\n"
cero: .float 0.0
uno:  .float 1.0

.text
.globl main
main:

    # --- Leer grado n ---
    li $v0, 4
    la $a0, msg1
    syscall

    li $v0, 5        # Leer entero (n)
    syscall
    move $s1, $v0    # s1 = n

    # Calcular bytes a reservar = (n+1) * 4
    addi $t0, $s1, 1
    li $t1, 4
    mul $a0, $t0, $t1

    # --- Reservar memoria dinámica ---
    li $v0, 9
    syscall
    move $s2, $v0    # s2 = puntero base de coeficientes

    # --- Leer coeficientes a0..an ---
    li $t1, 0        # i = 0
    move $t2, $s2    # puntero a coeficiente actual

coef_loop:
    bgt $t1, $s1, coef_end

    # Mostrar mensaje "Ingrese el coeficiente a"
    li $v0, 4
    la $a0, msg2
    syscall

    # Mostrar número del coeficiente (i)
    move $a0, $t1
    li $v0, 1
    syscall

    # Mostrar ": "
    li $v0, 4
    la $a0, dosPuntos
    syscall

    # Leer coeficiente entero
    li $v0, 5
    syscall
    sw $v0, 0($t2)

    # Salto de línea
    li $v0, 4
    la $a0, salto
    syscall

    addi $t2, $t2, 4
    addi $t1, $t1, 1
    j coef_loop

coef_end:

    # --- Leer valor x (float) ---
    li $v0, 4
    la $a0, msg3
    syscall

    li $v0, 6
    syscall
    mov.s $f1, $f0   # f1 = x

    # --- Evaluar el polinomio ---
    li $t1, 0
    move $t2, $s2
    l.s $f12, cero    # acumulador P(x) = 0.0

eval_loop:
    bgt $t1, $s1, eval_end

    lw $t3, 0($t2)
    mtc1 $t3, $f2
    cvt.s.w $f2, $f2  # f2 = float(ai)

    # calcular x^i
    l.s $f3, uno
    li $t4, 0

pow_loop:
    bge $t4, $t1, pow_end
    mul.s $f3, $f3, $f1
    addi $t4, $t4, 1
    j pow_loop
pow_end:

    mul.s $f4, $f2, $f3   # term = ai * x^i
    add.s $f12, $f12, $f4 # acumular en P(x)

    addi $t1, $t1, 1
    addi $t2, $t2, 4
    j eval_loop

eval_end:

    # --- Mostrar resultado ---
    li $v0, 4
    la $a0, msg4
    syscall

    li $v0, 2          # imprimir float (usa $f12)
    syscall

    # Salto final
    li $v0, 4
    la $a0, salto
    syscall

    # --- Fin del programa ---
    li $v0, 10
    syscall
