.data
bitmap: .space 2160 #32x16
ancho: .word 27
altura: .word 20
white: .word 0xFFFFFF
red: .word 0xFF0000

.text
la $t0, bitmap  # Dirección inicial del bitmap
lw $t1, white   # Valor del color blanco (0xFFFFFF)
lw $t2, ancho   # Ancho del bitmap (27)
lw $t3, altura  # Alto del bitmap (20)
li $t4, 0       # Contador de píxeles

fill_bitmap:
    beq $t4, 540, mod # Si se llenaron 540 píxeles, terminar
    sw $t1, 0($t0)          # Asignar el color blanco al píxel actual
    addi $t0, $t0, 4        # Mover al siguiente píxel (4 bytes por píxel)
    addi $t4, $t4, 1        # Incrementar el contador de píxeles
    j fill_bitmap
    
    
# Modificar un píxel específico (por ejemplo, el píxel en la posición [10, 10])
mod:
    la $t0, bitmap          # Dirección inicial del bitmap
    li $t5, 10              # Coordenada x del píxel
    li $t6, 10              # Coordenada y del píxel
    lw $t7, red             # Valor del color rojo (0xFF0000)
    mul $t8, $t6, $t2       # Calcular el offset: y * width
    add $t8, $t8, $t5       # Offset total: (y * width) + x
    sll $t8, $t8, 2         # Multiplicar por 4 (cada píxel ocupa 4 bytes)
    add $t0, $t0, $t8       # Dirección del píxel específico
    sw $t7, 0($t0)          # Establecer el color del píxel a rojo

end_fill:
    # Terminar el programa
    li $v0, 10
    syscall