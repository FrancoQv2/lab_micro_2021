    .cpu 	cortex-m4       // Indica el procesador de destino  
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

/* Definicion de variables globales ***************************************/

    .section .data          // Define la sección de variables (RAM)
datos:
    .byte   0x03,0x3A,0xAA,0xF2
base:
    .word   datos           // Apunta a la direccion base de 'datos'
    .space  1               // base+4 es byte para el resultado checksum

/* Programa principal *****************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func	main            // Indica al depurador el inicio de una funcion

reset:
    MOV     R0,#4           // R0 contiene la cantidad de elementos de 'datos'
    LDR     R1,=base        // Apunto R1 al inicio de 'base' (contiene el puntero a 'datos')
    LDR     R2,[R1]         // Guardo en R2 la direccion del 1er elemento de 'datos'
    MOV     R4,#0           // Uso R4 como contador (indice)
    MOV     R5,#0           // Uso R5 para guardar el resultado temporal
loop:
    CMP     R4,R0           // Comparo si se llegó al final del bloque 'datos'
    BEQ     final
    LDRB    R3,[R2,R4]      // En R3 guardo el valor base+R4 (ej: R3 <- 0xAA(base+2))
    ADD     R4,#1           // Incremento en 1 el contador
    ADD     R5,R3           // En R5 guardo R5+R3 (R5 <- R5 + M[base+R4])
    B       loop
final:
    STRB    R5,[R1,R4]      // Guardo el resultado en base+4
stop:
    B       stop            // Lazo infinito para detener

    .pool                   // Almacenar las constantes de código
    .endfunc
