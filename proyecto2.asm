.data
reserva: .space 567
ast_izq: .word 60
ast_der: .word 62
nl: .asciiz "\n"
point: .word 46
tiempo: .space 40
choque: .asciiz "Oh no! Has colisionado"
pedir: .asciiz "Indique si desea que la nave avance o retroceda (W para avanzar y S para retroceder): "
letra: .space 2
	.asciiz ""

.text
li $t4 2
sw $t4 0xffff0000
# Se cargan necesarias para el programa
la $s0 reserva
lw $t1 ast_izq
lw $t2 ast_der
lw $t4 point
la $s1 tiempo

#Se guarda la linea de teimpo "||"
linea_t:
	beq $t0 40 p_primera_fila
	li $t3 124
	sb $t3 0($s1)
	addi $s1 $s1 1
	addi $t0 $t0 1
	j linea_t

#Previo a imprimir la primera fila de puntos
p_primera_fila: li $t0 0

# La primera fila de puntos
primera_fila:
	bge $t0 27 loop1
	sb $t4 0($s0)
	addi $s0 $s0 1
	addi $t0 $t0 1
	j primera_fila
	
# Se asignan asteroides de izquierda <
loop1:
	bge $t0 486 previo
	sb $t4 0($s0)
	jal random
	add $s0 $s0 $a0
	sb $t1 1($s0)
	jal resto
	add $s0 $s0 $t5
	sb $t4 0($s0)
	addi $s0 $s0 1
	addi $t0 $t0 27
	j loop2

# Se asignan asteroides de derecha >
loop2:
	bge $t0 486 previo
	sb $t4 0($s0)
	jal random
	add $s0 $s0 $a0
	sb $t2 1($s0)
	jal resto
	add $s0 $s0 $t5
	sb $t4 0($s0)
	addi $s0 $s0 1
	addi $t0 $t0 27
	j loop1

# Se genera de manera aleatoria la posicion del asteroide
random:
	li $v0,30
	syscall
	move $a1,$a0
	li $a0,1
	li $v0,40
	syscall
	li $v0,42
	li $a0,1
	li $a1,25
	syscall	
	jr $ra

# Calcular el resto de casillas que falta para la nueva fila	
resto:
	li $t5 26
	sub $t5 $t5 $a0
	jr $ra

#Se guarda en el tablero la nave del usuario	
previo:
	addi $s0 $s0 12
	addi $t0 $t0 12
	li $t1 47
	sb $t1 0($s0)
	li $t1 92
	sb $t1 1($s0)
	add $s0 $s0 27
	addi $t0 $t0 27
	li $t1 124
	sb $t1 0($s0)
	sb $t1 1($s0)
	add $s0 $s0 27
	addi $t0 $t0 27
	li $t1 47
	sb $t1 0($s0)
	li $t1 92
	sb $t1 1($s0)
	addi $s0 $s0 1
	addi $t0 $t0 1
	
	subi $s0 $s0 553
	li $t0 0
	li $t1 0
	
	j print

# Se imprime el tablero
print:
	beq $t1 21 p_bucle_principal
	beq $t0 27 next
	li $v0 11
	lb $t3 0($s0)
	
	beqz $t3 space

	move $a0 $t3
	syscall
	
	addi $s0 $s0 1
	addi $t0 $t0 1
	j print

# Si hay un 0, se imprime un espacio	
space:
	addi $t3 $t3 32
	move $a0 $t3
	syscall
	
	addi $s0 $s0 1
	addi $t0 $t0 1
	j print

# Siguiente fila
next:
	li $v0 4
	la $a0 nl
	syscall
	
	li $t0 0
	addi $t1 $t1 1
	j print

# Se deja la posicion del tablero en el 0,0
p_bucle_principal: subi $s0 $s0 540
	lb $t1 0($s0)





bucle_principal:
	
	li $v0,32
	li $a0,200
	syscall
	
	li $t0 0
	jal mover_ast
	li $t1 0
	subi $s0 $s0 27
	j reiniciar
	

# Se mueven los asteroides de izquierda a derecha	
mover_ast:
	beq $t0 458 reverse
	lb $t1 1($s0)
	beq $t1 60 izquierda
	addi $s0 $s0 1
	addi $t0 $t0 1
	j mover_ast

#Si el asteroide es <, entonces dos casos
izquierda:
	lb $t2 0($s0)
	beq $t2 46 ir_al_final
	beqz $t2 mover_izquierda
	j colision


# Caso 1: .<     ., debemos tener .    <.	
ir_al_final:

	sb $zero 1($s0)
	addi $s0 $s0 24
	sb $t1 1($s0)
	addi $s0 $s0 2
	addi $t0 $t0 26
	j mover_ast
	
# Caso 2: .   <   ., debemos tener .   <     .
mover_izquierda:

	sb $zero 1($s0)
	sb $t1 0($s0)
	addi $s0 $s0 1
	addi $t0 $t0 1
	j mover_ast
	
	
	
	
	

reverse: 
	beqz $t0 volver
	lb $t1 0($s0)
	beq $t1 62 derecha
	subi $s0 $s0 1
	subi $t0 $t0 1
	j reverse
	
# Si el asteroide es >, entoneces dos casos
derecha:
	lb $t2 1($s0)
	beq $t2 46 ir_al_comienzo
	beqz $t2 mover_derecha
	j colision

# Caso 1: .    >., entonces .>     .
ir_al_comienzo:
	sb $zero 0($s0)
	subi $s0 $s0 24
	sb $t1 0($s0)
	subi $s0 $s0 3
	subi $t0 $t0 27

	j reverse

# Caso 2: .   >   ., entonces .     >  .
mover_derecha:

	sb $zero 0($s0)
	sb $t1 1($s0)
	subi $s0 $s0 1
	subi $t0 $t0 1

	j reverse
	
# Se reinician las variables y se deja en 0,0 el tablero
reiniciar:
	jal imprimir
	subi $s0 $s0 540
	j bucle_principal
	

# Ayuda para los jal y jr
volver:
	
	jr $ra
	
# Ocurrio una colision	
colision:
	li $v0 4
	la $a0 choque
	syscall
	j end

imprimir:
	beq $t1 21 volver
	beq $t0 27 sgte
	li $v0 11
	lb $t3 0($s0)
	
	beqz $t3 espacio

	move $a0 $t3
	syscall
	
	addi $s0 $s0 1
	addi $t0 $t0 1
	j imprimir

# Si hay un 0, se imprime un espacio	
espacio:
	addi $t3 $t3 32
	move $a0 $t3
	syscall
	
	addi $s0 $s0 1
	addi $t0 $t0 1
	j print

sgte:
	li $v0 4
	la $a0 nl
	syscall
	
	li $t0 0
	addi $t1 $t1 1
	j print


# Fin
end:	
	li $v0 10
	syscall





###################################################################
###                                                             ###
###################################################################





.kdata
_choque: .asciiz "Ocurrio colision"
_no_se_puede: .asciiz "No se puede retroceder del home"

.ktext 0x80000180

	lw $k0 0xffff0004
	
# Leer opcion del piloto (avanzar o retroceder
mover_piloto:
	jal buscar
	beq $k0 87 avanzar
	beq $k0 119 avanzar
	beq $k0 83 retroceder
	beq $k0 115 retroceder
	j mover_piloto

buscar:
	lb $t8 0($s0)
	beq $t8 47 regresar
	addi $s0 $s0 1
	addi $t7 $t7 1
	j buscar
	
regresar: jr $ra

# Se avanza: se verifica si llego a la meta, si en la casilla 0 o 1 hay asteroide que colisione con la nave	
avanzar:
	lb $t1 0($s0)
	lb $t2 1($s0)
	beq $t1 46 meta
	or $t3 $t1 $t2
	bnez $t3 verificar

	lb $t3 0($s0)
	lb $t4 1($s0)
	sb $zero 0($s0)
	sb $zero 1($s0)
	subi $s0 $s0 27
	sb $t3 0($s0)
	sb $t4 1($s0)
	addi $s0 $s0 54
	
	lb $t3 0($s0)
	lb $t4 1($s0)
	sb $zero 0($s0)
	sb $zero 1($s0)
	subi $s0 $s0 27
	sb $t3 0($s0)
	sb $t4 1($s0)
	addi $s0 $s0 54
	
	lb $t3 0($s0)
	lb $t4 1($s0)
	sb $zero 0($s0)
	sb $zero 1($s0)
	subi $s0 $s0 27
	sb $t3 0($s0)
	sb $t4 1($s0)
	sub $s0 $s0 $t7
	addi $s0 $s0 27
	
	j fin_interrupcion


# El jugador llego a la meta
meta:
	addi $s0 $s0 27
	li $t3 32
	lb $t1 0($s0)
	lb $t2 1($s0)
	sb $t3 0($s0)
	sb $t3 1($s0)
	addi $s0 $s0 459
	sb $t1 0($s0)
	sb $t2 1($s0)
	
	subi $s0 $s0 432
	lb $t1 0($s0)
	lb $t2 1($s0)
	sb $t3 0($s0)
	sb $t3 1($s0)
	addi $s0 $s0 432
	sb $t1 0($s0)
	sb $t2 1($s0)
	
	subi $s0 $s0 405
	lb $t1 0($s0)
	lb $t2 1($s0)
	sb $t3 0($s0)
	sb $t3 1($s0)
	addi $s0 $s0 405
	sb $t1 0($s0)
	sb $t2 1($s0)
	j fin_interrupcion
	
	
# Verificar si hay un asteroide > en la posicion 0 que al mever colisone con la posicion 1, y viceversa	
verificar:
	beq $t1 62 colision_k
	beq $t2 60 colision_k
	addi $s0 $s0 27
	lb $t3 0($s0)
	lb $t4 1($s0)
	sb $zero 0($s0)
	sb $zero 1($s0)
	subi $s0 $s0 27
	sb $t3 0($s0)
	sb $t4 1($s0)
	addi $s0 $s0 42
	addi $t5 $t5 1
	j avanzar
	
# Retroceder: Se debe crear una variable que indique la candtidad de veces que ha avanzado el piloto. Si la variable es igual a 0, entonces no puede retroceder
retroceder:
	blez $t9 no
	addi $s0 $s0 81
	lb $t1 0($s0)
	lb $t2 1($s0)
	or $t3 $t1 $t2
	bnez $t3 verificar
	
	subi $s0 $s0 27
	lb $t1 0($s0)
	lb $t2 1($s0)
	sb $zero 0($s0)
	sb $zero 1($s0)
	addi $s0 $s0 27
	sb $t1 0($s0)
	sb $t2 1($s0)
	
	subi $s0 $s0 54
	lb $t1 0($s0)
	lb $t2 1($s0)
	sb $zero 0($s0)
	sb $zero 1($s0)
	addi $s0 $s0 27
	sb $t1 0($s0)
	sb $t2 1($s0)
	
	subi $s0 $s0 54
	lb $t1 0($s0)
	lb $t2 1($s0)
	sb $zero 0($s0)
	sb $zero 1($s0)
	addi $s0 $s0 27
	sb $t1 0($s0)
	sb $t2 1($s0)
	sub $s0 $s0 $t7
	subi $s0 $s0 27
	
	j fin_interrupcion

no:
	li $v0 4
	la $a0 _no_se_puede
	syscall
	j fin_interrupcion
	
# Ocurrio una colision	
colision_k:
	li $v0 4
	la $a0 _choque
	syscall
	
fin_interrupcion:
	li $t7 0
	eret
