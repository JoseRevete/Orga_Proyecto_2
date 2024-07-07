.data

display: .space 4096
ast: .word 60

.text

li $t0 0xff0000
li $t2 0x00ff00
li $t1 0
li $t3 0

loop:
	beq $t1 4096 end

	sw $t0 display($t1)
	
	addi $t1 $t1 4
	
	sw $t2 display($t1)
	
	addi $t1 $t1 4
	
	j loop
	
end:
	lw $t0 ast
	subi $t1 $t1 4096
	addi $t1 $t1 116
	sw $t0 display($t1)

	li $v0 10
	syscall
