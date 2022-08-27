    .cpu 	cortex-m4       // Indica el procesador de destino  
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

/* Definicion de variables globales ***************************************/

    .section .data           // Define la sección de variables (RAM)
cadena:
    .asciz  "SISTEMAS CON MICROPROCESADORE"

/* Programa principal *****************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func	main            // Indica al depurador el inicio de una funcion

reset:
    LDR     R0,=cadena      // Apunto R0 a 'cadena' (direccion base)
    MOV     R2,#0           // Indice de la cadena
    LDRB    R1,[R0]         // Cargo en R1 el 1er caracter
buscar_ultimo:
    CMP     R1,0x00         // Verifico si llego al final de la cadena
    BEQ     llamada_func
    LDRB    R1,[R0,#1]!     // Si no llego cargo cadena[i+1]
    ADD     R2,#1           // Incremento el contador
    B       buscar_ultimo
llamada_func:
    LDR     R0,=cadena
    SUB     R2,#1           // Obtengo el indice del ultimo caracter
    ADD     R1,R0,R2        // Apunto R1 a la direccion del ultimo caracter
    @ BL      cambiar
    PUSH    {R0-R2}
    BL      invertir
    POP     {R0-R2}
stop:
    B       stop            // Lazo infinito para detener

    .pool                   // Almacenar las constantes de código
    .endfunc

/* 
    Rutina para cambiar el 1er caracter de una cadena ASCII
    con el ultimo caracter
    Recibe en R0 la direccion base de la cadena
    Recibe en R1 la direccion del ultimo caracter
*/
    .func   cambiar
cambiar:
    PUSH    {R4,R5}
    LDRB    R4,[R0]         // Cargo el 1er caracter de la cadena en R4
    LDRB    R5,[R1]         // Cargo el ultimo caracter en R4
    STRB    R5,[R0]         // Guardo el ultimo caracter en cadena[0]
    STRB    R4,[R1]         // Guardo el 1er caracter en cadena[n-1]
    POP     {R4,R5}
    BX      LR
    .pool
    .endfunc

/* 
    Rutina recursiva para invertir el orden de una cadena ASCII
    Recibe en R0 la direccion base de la cadena
    Recibe en R1 la direccion del ultimo caracter
*/
    .func   invertir
invertir:
    CMP     R2,
    BEQ     fin
    STRB    R4,[R0]
    STRB    R5,[R1]
    ADD     R0,#1
    SUB     R1,#1

    LDRB    R4,[R0]         // Cargo el 1er caracter de la cadena en R4
    MOV     R5,R4           // Lo copio en R5
    LDRB    R4,[R1]         // Cargo el ultimo caracter en R4
    STRB    R4,[R0]         // Guardo el ultimo caracter en cadena[0]
    STRB    R5,[R1]         // Guardo el 1er caracter en cadena[n-1]

    BL      invertir
fin:
    BX      LR
    .pool
    .endfunc

