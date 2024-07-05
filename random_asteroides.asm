.data
reserva: .space 540
ast_izq: .asciiz "<"
ast_der: .asciiz ">"
nl: .asciiz "\n"
p1: .asciiz "/\\"
p2: .asciiz "||"
point: .word 14

.text
la $s0 reserva
la $t1 ast_izq
la $t2 ast_der
lw $t4 point

primera_fila:
	bge $t0 27 loop1
	sb $t4 0($s0)
	addi $s0 $s0 1
	addi $t0 $t0 1
	j primera_fila
	

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
	
resto:
	li $t5 26
	sub $t5 $t5 $a0
	jr $ra
	
previo:

	li $v0 11
	lb $t6 0($s0)
	move $a0 $t6
	syscall

	addi $s0 $s0 13
	addi $t0 $t0 13
	la $t1 p1
	sb $t1 0($s0)
	add $s0 $s0 27
	addi $t0 $t0 27
	la $t1 p2
	sb $t1 0($s0)
	add $s0 $s0 27
	addi $t0 $t0 27
	la $t1 p1
	sb $t1 0($s0)
	
	subi $s0 $s0 553
	li $t0 0
	li $t1 0
	
	j print
	
print:
	beq $t1 18 end
	beq $t0 27 next
	
	li $v0 11
	lb $t3 0($s0)
	
	beqz $t3 space
	
	addi $t3 $t3 32 #
	move $a0 $t3
	syscall
	
	addi $s0 $s0 1
	addi $t0 $t0 1
	j print
	
space:
	addi $t3 $t3 32
	move $a0 $t3
	syscall
	
	addi $s0 $s0 1
	addi $t0 $t0 1
	j print
	
next:
	li $v0 4
	la $a0 nl
	syscall
	
	li $t0 0
	addi $t1 $t1 1
	j print
	
end:
	addi $s0 $s0 13
	lb $t3 0($s0)
	addi $t3 $t3 268501504
	li $v0 4
	move $a0 $t3
	syscall
	
	addi $s0 $s0 27
	lb $t3 0($s0)
	addi $t3 $t3 268501504
	li $v0 4
	move $a0 $t3
	syscall
	
	addi $s0 $s0 27
	lb $t3 0($s0)
	addi $t3 $t3 268501504
	li $v0 4
	move $a0 $t3
	syscall
	
	li $v0 10
	syscall