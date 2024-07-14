.data
reserva: .space 567
ast_izq: .word 60
ast_der: .word 62
nl: .asciiz "\n"
point: .word 46
choque: .asciiz "Oh no! Has colisionado. Deseas volver a jugar? (Responde '0' para no o '1' para si): "
respuesta: .space 4
	.asciiz ""
rechazar: .asciiz "Respuesta no valida\n\n"
pedir: .asciiz "Indique si desea que la nave avance o retroceda (W para avanzar y S para retroceder)"
letra: .space 2
	.asciiz ""
laps: .asciiz "Vueltas hechas: "
t: .asciiz "o"
tiempo_finalizado: .asciiz "Se ha acabado el tiempo. Deseas volver a jugar? (Responde '0' para no o '1' para si): "
a1: .asciiz "  _____  _____    ____    ____  _____      ____    ____    ____  _____\n"
a2: .asciiz " / ____||  __ \\  / __ \\  / ___|| ____|    |    \\  / __ \\  / ___|| ____|\n"          
a3: .asciiz "| (___  | |__) || |  | || /    | |__      | |\\  || |  | || /    | |__ \n"  
a4: .asciiz " \\___ \\ |  ___/ | |__| || |    |  __|     | |/ / | |__| || |    |  __|\n"            
a5: .asciiz " ____)  | |     |  __  || \\___ | |___     |  _ \\ |  __  || \\___ | |___\n"                 
a6: .asciiz "|_____/ |_|     |_|  |_| \\____||_____|    |_| \\_\\|_|  |_| \\____||_____|\n"
bienvenido: .asciiz "Bienvenido a Space Race. Te dare una nave, espero la cuides.\n Las reglas son simples: intenta hacer la mayor cantidad de vueltas en 100 segundos sin chocar con los asteroides.\n ¿Como te mueves? Pues presionando w para avanzar y s para retroceder.\n\n¡Suerte piloto! No destruyas tu nave"
gracias: .asciiz "\n Y eso fue todo, gracias por jugar, veo que la nave esta casi como nueva.\n¡Vuelve pronto!\n"


.text
li $v0 4
la $a0 a1
syscall
la $a0 a2
syscall
la $a0 a3
syscall
la $a0 a4
syscall
la $a0 a5
syscall
la $a0 a6
syscall
li $v0,32
li $a0,3000
syscall
li $t4 2
sw $t4 0xffff0000
# Se cargan necesarias para el programa
la $s0 reserva
lw $t1 ast_izq
lw $t2 ast_der
lw $t4 point
li $s4 20

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
	li $v0,32
	li $a0,10
	syscall
	
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
	
	midprint:
	la      $s6,0xffff0000
	lw      $s7,0x0008($s6)                
    	andi    $s7,$s7,1
    	beq     $s7,$zero,midprint
	move $a0 $t3
	sb      $a0,0x000c($s6)
	syscall
	
	addi $s0 $s0 1
	addi $t0 $t0 1
	j print

# Si hay un 0, se imprime un espacio	
space:
	la      $s6,0xffff0000
	lw      $s7,0x0008($s6)                
    	andi    $s7,$s7,1               
    	beq     $s7,$zero,space
	addi $t3 $t3 32
	move $a0 $t3
	sb      $a0,0x000c($s6)
	syscall
	
	addi $s0 $s0 1
	addi $t0 $t0 1
	j print

# Siguiente fila
next:
	la      $s6,0xffff0000
	lw      $s7,0x0008($s6)                
    	andi    $s7,$s7,1               
    	beq     $s7,$zero,next
	li $v0 4
	la $a0 nl
	
	syscall
	li $a0,10
	sb      $a0,0x000c($s6)
	li $t0 0
	addi $t1 $t1 1
	j print

# Se deja la posicion del tablero en el 0,0
p_bucle_principal: subi $s0 $s0 540
	lb $t1 0($s0)




# Ciclo para mover asteroides y actualizar el tablero
bucle_principal:
	
	li $v0,32
	li $a0,180
	syscall
	
	li $t0 0
	jal mover_ast
	li $t1 0
	subi $s0 $s0 27
	j reiniciar
	

# Se mueven los asteroides de izquierda a derecha	
mover_ast:
	beq $t9 -1 colision
	beq $t0 458 reverse
	lb $t1 1($s0)
	beq $t1 60 izquierda
	addi $s0 $s0 1
	addi $t0 $t0 1
	j mover_ast

#Si el asteroide es <, entonces dos casos
izquierda:
	beq $t9 -1 colision
	lb $t2 0($s0)
	beq $t2 46 ir_al_final
	beqz $t2 mover_izquierda
	j colision


# Caso 1: .<     ., debemos tener .    <.	
ir_al_final:
	beq $t9 -1 colision
	sb $zero 1($s0)
	addi $s0 $s0 24
	sb $t1 1($s0)
	addi $s0 $s0 2
	addi $t0 $t0 26
	j mover_ast
	
# Caso 2: .   <   ., debemos tener .   <     .
mover_izquierda:
	beq $t9 -1 colision
	sb $zero 1($s0)
	sb $t1 0($s0)
	addi $s0 $s0 1
	addi $t0 $t0 1
	j mover_ast
	
	
	
	
	
# Mover los asteroides de derecha a izquierda
reverse:
	beq $t9 -1 colision
	beqz $t0 volver
	lb $t1 0($s0)
	beq $t1 62 derecha
	subi $s0 $s0 1
	subi $t0 $t0 1
	j reverse
	
# Si el asteroide es >, entoneces dos casos
derecha:
	beq $t9 -1 colision
	lb $t2 1($s0)
	beq $t2 46 ir_al_comienzo
	beqz $t2 mover_derecha
	j colision

# Caso 1: .    >., entonces .>     .
ir_al_comienzo:
	beq $t9 -1 colision
	sb $zero 0($s0)
	subi $s0 $s0 24
	sb $t1 0($s0)
	subi $s0 $s0 3
	subi $t0 $t0 27

	j reverse

# Caso 2: .   >   ., entonces .     >  .
mover_derecha:
	beq $t9 -1 colision
	sb $zero 0($s0)
	sb $t1 1($s0)
	subi $s0 $s0 1
	subi $t0 $t0 1

	j reverse
	
# Se reinician las variables y se deja en 0,0 el tablero
reiniciar:
	beq $t9 -1 colision
	jal imprimir
	li $s0 268501019
	j bucle_principal
	

# Ayuda para los jal y jr
volver:
	beq $t9 -1 colision
	jr $ra
	
# Ocurrio una colision	
colision:
	li $s0 268501019
	j buscar_piloto
	
# Se busca la posicion del piloto
buscar_piloto:
	lb $t4 0($s0)
	beq $t4 47 borrar_piloto
	addi $s0 $s0 1
	addi $t7 $t7 1
	j buscar_piloto

#Se borra el piloto de su posicion actual
borrar_piloto:
	sb $zero  0($s0)
	sb $zero  1($s0)
	addi $s0 $s0 27
	sb $zero  0($s0)
	sb $zero  1($s0)
	addi $s0 $s0 27
	sb $zero  0($s0)
	sb $zero  1($s0)
	li $s0 268501478
	j dibujar_piloto
	
# Se dibuja al piloto en el home
dibujar_piloto:
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
	
	subi $s0 $s0 552
	li $t0 0
	li $t1 0
	li $t9 0
	beq $t8 -1 en_cero
	
#Imprimir el tablero
imprimir:
	beq $t9 -1 colision
	beq $t1 21 linea_laps
	beq $t0 27 sgte
	li $v0 11
	lb $t3 0($s0)
	
	beqz $t3 espacio

	midimprimir:
	la      $s6,0xffff0000
	lw      $s7,0x0008($s6)                
    	andi    $s7,$s7,1
    	beq     $s7,$zero,midimprimir
	move $a0 $t3
	sb      $a0,0x000c($s6)
	syscall
	
	addi $s0 $s0 1
	addi $t0 $t0 1
	j imprimir
	
# Si hay un 0, se imprime un espacio	
espacio:
	beq $t9 -1 colision
	la      $s6,0xffff0000
	lw      $s7,0x0008($s6)                
    	andi    $s7,$s7,1               
    	beq     $s7,$zero,espacio
	addi $t3 $t3 32
	move $a0 $t3
	sb      $a0,0x000c($s6)
	syscall
	
	addi $s0 $s0 1
	addi $t0 $t0 1
	j imprimir

#Siguiente linea en el tablero
sgte:
	beq $t9 -1 colision
	la      $s6,0xffff0000
	lw      $s7,0x0008($s6)                
    	andi    $s7,$s7,1               
    	beq     $s7,$zero,sgte
	li $v0 4
	la $a0 nl

	syscall
	li $a0,10
	sb      $a0,0x000c($s6)
	
	li $t0 0
	addi $t1 $t1 1
	j imprimir
	
# Conteo de laps
linea_laps:
	li $v0 4
	la $a0 laps
	syscall
	
	li $v0 1
	move $a0 $s2
	syscall
	
	li $v0 4
	la $a0 nl
	syscall
	move $t4 $s4
	addi $s3 $s3 1
	
# Imprime el tiempo constante
print_tiempo:
	beq $s3 25 p_tiempo
	beqz $s4 tiempo_agotado
	beqz $t4 volver_t
	li $v0 4
	la $a0 t
	syscall
	subi $t4 $t4 1
	j print_tiempo
	
# Auxiliar para reducir el tiempo en uno
p_tiempo: subi $s4 $s4 1
	subi $t4 $t4 1

#Imprime el tiempo cuando hay que reducir uno
tiempo:
	beqz $s4 tiempo_agotado
	beqz $t4 volver_t
	li $v0 4
	la $a0 t
	syscall
	subi $t4 $t4 1
	move $s3 $zero
	j tiempo
	
# Tiempo agotado. Preguntar si desea volver a jugar
tiempo_agotado:
	li $v0 4
	la $a0 tiempo_finalizado
	syscall
	li $v0 5
	la $a0 respuesta
	li $a1 3
	syscall
	move $t0 $v0
	beq $t0 1 p_reinicio
	beqz $t0 end
	li $v0 4
	la $a0 rechazar
	syscall
	j tiempo_agotado
	
# Reiniciar juego
p_reinicio:
	li $t8 -1
	j colision

# Volver al bucle principal
volver_t:
	li $s0 268501046
	li $v0 4
	la $a0 nl
	syscall
	li $v0,32
	li $a0,10
	syscall
	j volver
	
# Colocar todo en 0 para el reinicio del tablero
en_cero:
	li $t0 0
	li $t1 0
	li $t2 0
	li $t3 0
	li $t4 0
	li $t5 0
	li $t6 0
	li $t7 0
	li $t8 0
	li $t9 0
	move $at $zero
	move $v0 $zero
	move $s7 $zero
	li $s0 268500992
	move $s1 $zero
	move $s2 $zero
	move $s3 $zero
	li $s4 20
	move $s5 $zero
	move $s6 $zero
	move $s7 $zero
	move $k0 $zero
	j imprimir
	
# Fin
end:	
	li $v0 4
	la $a0 gracias
	syscall
	
	la $a0 laps
	syscall
	li $v0 1
	move $a0 $s2
	syscall	
	li $v0 10
	syscall





###################################################################
###                                                             ###
###################################################################





.kdata
_choque: .asciiz "Ocurrio colision\n"
_no_se_puede: .asciiz "No se puede retroceder del home\n"
_none: .asciiz "Se ha introducido un caracter distinto de W,w,S,s\n"

.ktext 0x80000180

# Caracter ngresado por el usuario 
	lw $k0 0xffff0004
	beqz $t9 ver
	
# Si se ingresa un caracter correcto con respecto a la posicion a la nave en el atblero, seguir
seguir:
	subi $t8 $s0 268501019
	sub $s0 $s0 $t8
	j mover_piloto
	
# Si la nave esta en el home y se intenta retroceder, se pasa
ver:
	beq $k0 83 fin
	beq $k0 115 fin
	j seguir
	
# Leer opcion del piloto (avanzar o retroceder)
mover_piloto:
	j buscar
	
# Opcion dada por el usuario
mover:
	beq $k0 87 avanzar
	beq $k0 119 avanzar
	beq $k0 83 retroceder
	beq $k0 115 retroceder
	j ninguno
	
# Caracter ingresado distinto de W,w,S,s
ninguno:
	li $v0 4
	la $a0 _none
	syscall
	j fin_interrupcion

# Buscar posicion de la nave
buscar:
	lb $t4 0($s0)
	beq $t4 47 mover
	addi $s0 $s0 1
	addi $t7 $t7 1
	j buscar

# Se avanza: se verifica si llego a la meta, si en la casilla 0 o 1 hay asteroide que colisione con la nave	
avanzar:
	
	subi $s0 $s0 27
	lb $t4 0($s0)
	lb $t5 1($s0)
	beq $t4 46 meta
	or $t6 $t4 $t5
	beq $t6 62 colision_k
	beq $t6 60 colision_k

	addi $s0 $s0 27
	lb $t4 0($s0)
	lb $t5 1($s0)
	sb $zero 0($s0)
	sb $zero 1($s0)
	subi $s0 $s0 27
	sb $t4 0($s0)
	sb $t5 1($s0)
	addi $s0 $s0 54
	
	lb $t4 0($s0)
	lb $t5 1($s0)
	sb $zero 0($s0)
	sb $zero 1($s0)
	subi $s0 $s0 27
	sb $t4 0($s0)
	sb $t5 1($s0)
	addi $s0 $s0 54
	
	lb $t4 0($s0)
	lb $t5 1($s0)
	sb $zero 0($s0)
	sb $zero 1($s0)
	subi $s0 $s0 27
	sb $t4 0($s0)
	sb $t5 1($s0)
	sub $s0 $s0 $t7
	add $s0 $s0 $t8
	subi $s0 $s0 54
	addi $t9 $t9 1
	
	j fin_interrupcion


# El jugador llego a la meta
meta:
	addi $s0 $s0 27
	lb $t4 0($s0)
	lb $t5 1($s0)
	sb $zero 0($s0)
	sb $zero 1($s0)
	addi $s0 $s0 459
	sb $t4 0($s0)
	sb $t5 1($s0)
	
	subi $s0 $s0 432
	lb $t4 0($s0)
	lb $t5 1($s0)
	sb $zero 0($s0)
	sb $zero 1($s0)
	addi $s0 $s0 459
	sb $t4 0($s0)
	sb $t5 1($s0)
	
	subi $s0 $s0 432
	lb $t4 0($s0)
	lb $t5 1($s0)
	sb $zero 0($s0)
	sb $zero 1($s0)
	addi $s0 $s0 459
	sb $t4 0($s0)
	sb $t5 1($s0)
	subi $s0 $s0 459
	sub $s0 $s0 $t7
	add $s0 $s0 $t8
	subi $s0 $s0 81
	addi $s2 $s2 1
	li $t9 0
	j fin_interrupcion
	

# Retroceder la nave, incluye comprobacion de su el si aquella esta en el home
retroceder:
	beqz $t9 no
	addi $s0 $s0 81
	lb $t4 0($s0)
	lb $t5 1($s0)
	or $t6 $t4 $t5
	beq $t6 62 colision_k
	beq $t6 60 colision_k
	
	subi $s0 $s0 27
	lb $t4 0($s0)
	lb $t5 1($s0)
	sb $zero 0($s0)
	sb $zero 1($s0)
	addi $s0 $s0 27
	sb $t4 0($s0)
	sb $t5 1($s0)
	
	subi $s0 $s0 54
	lb $t4 0($s0)
	lb $t5 1($s0)
	sb $zero 0($s0)
	sb $zero 1($s0)
	addi $s0 $s0 27
	sb $t4 0($s0)
	sb $t5 1($s0)
	
	subi $s0 $s0 54
	lb $t4 0($s0)
	lb $t5 1($s0)
	sb $zero 0($s0)
	sb $zero 1($s0)
	addi $s0 $s0 27
	sb $t4 0($s0)
	sb $t5 1($s0)
	sub $s0 $s0 $t7
	add $s0 $s0 $t8
	subi $s0 $s0 54
	subi $t9 $t9 1
	
	j fin_interrupcion

# No permitir retroceder ne el home
no:
	li $v0 4
	la $a0 _no_se_puede
	syscall
	sub $s0 $s0 $t7
	subi $s0 $s0 27
	j fin_interrupcion
	
# Ocurrio una colision	
colision_k:
	li $t9 -1
	
# Finalizar interrupcion con movimiento
fin_interrupcion:
	addi $s0 $s0 27
	sw $zero 0xffff0004
	li $t7 0
	eret
	
# Finalizar interrupcion sin movimiento
fin:
	sw $zero 0xffff0004
	eret
