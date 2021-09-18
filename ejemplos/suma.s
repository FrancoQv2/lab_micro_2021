        .cpu cortex-m4
        .syntax unified
        .thumb
        .section .data
        .equ tamanio,4
        
num1:   .byte 0x85, 0x09    // Números a sumar
num2:   .byte 0x59, 0x04
resl:   .space 2            // Espacio para resultado
        .align
base:   .word num1          // Estructura con los
        .word num2          // punteros a los datos
        .word resl          // y al resultado
        .section .text
        .global reset

reset:
    MOV R3,#4/2         // Cantidad de byte por operando
    LDR R0,=base        // Puntero a la estructura
    LDR R1,[R0]         // Puntero al primer operando
    LDR R2,[R0,#4]      // Puntero al segundo operando
    LDR R0,[R0,#8]      // Puntero al resultado
lazo:
    CMP R3,0            // Comparo para salir de lazo
    BEQ final
    LDRB R4,[R1],#1     // Byte actual primer operando
    LDRB R5,[R2],#1     // Byte actual segundo operando
    ADD R4,R5
    ADD R4,R7           // Suma del acarreo
    MOV R7,#0
    AND R5,R4,0x0F      // Nibble inferior del resultado
    CMP R5,0x0A         // Comparación con diez
    IT HS
    ADDHS R4,R4,#0x06   // Suma seis si mayor a diez
    AND R5,R4,0xF0      // Nibble superior del resultado
    CMP R5,0xA0         // Comparación con diez
    ITT HS
    ADDHS R4,R4,#0x60   // Suma seis si mayor a diez
    MOVHS R7,#1         // Bandera de acarreo en uno
    SUB R3,R3,#1        // Decremento del contador
    STRB R4,[R0],#1     // Almacenamiento del resultado
    B lazo
final:
stop:
    B stop              // Lazo infinito
    
    .align
    .pool