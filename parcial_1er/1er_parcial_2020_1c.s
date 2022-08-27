    .cpu 	cortex-m4       // Indica el procesador de destino  
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

/* Definicion de variables globales ***************************************/

    .section .data          // Define la sección de variables (RAM)
vector:
    .byte   0xA7,0x7B,0x64,0x06,0x7A,0x03,0x3A,0xAD,0xF2,0xC1
    .space  6,0x00
resultado:
    .space  16,0x00

/* Programa principal *****************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func	main            // Indica al depurador el inicio de una funcion
reset:
    LDR     R0,=vector
    LDR     R1,=resultado
    MOV     R2,#10
    BL      codificacion_MIME
stop:
    B       stop            // Lazo infinito para detener

    .pool                   // Almacenar las constantes de código
    .endfunc

/* 
    Codifica los n multiplos de 3 bytes de un bloque de datos binario
*/
    .func	codificacion_MIME
codificacion_MIME:
    PUSH    {R4-R7}
    MOV     R7,#3
    UDIV    R6,R6,R7        // Obtengo la cantidad de conjutos de 3 bytes que hay dentro

loop:
    CMP     R6,#0           // Si termino vuelvo al main
    BEQ     final

    SUB     R6,#1           // Voy restando de a uno la cantidad de conjuntos de 3 bytes
    BL      codif_MIME
    

    ADD     R4,#3
    B       loop

final:
    POP     {R4-R7}
    BX      LR
    .pool                   // Almacenar las constantes de código
    .endfunc


/* 
    Codificacion MIME de 3 bytes exactos a 4 caracteres ASCII
*/
    .func	codif_MIME
codif_MIME:
    PUSH    {R7-R9}
    MOV     R9,#0x3F        // Mascara para obtener 6 bits
    LDR     R7,[R4]

    AND     R8,R7,R9        // Hago un AND para obtener los 6 primeros bits
    STRB    R8,[R5],#1      // Guardo en 'resultado' el 1er caracter codificado y luego desplazo un lugar

    LSR     R7,R7,#6
    AND     R8,R7,R9        // Hago un AND para obtener los 6 primeros bits
    STRB    R8,[R5],#1      // Guardo en 'resultado+1' el 2do caracter codificado y luego desplazo un lugar

    LSR     R7,R7,#6
    AND     R8,R7,R9        // Hago un AND para obtener los 6 primeros bits
    STRB    R8,[R5],#1      // Guardo en 'resultado+2' el 3er caracter codificado y luego desplazo un lugar

    LSR     R7,R7,#6
    AND     R8,R7,R9        // Hago un AND para obtener los 6 primeros bits
    STRB    R8,[R5],#1      // Guardo en 'resultado+3' el 4to caracter codificado y luego desplazo un lugar

    POP     {R7-R9}
    BX      LR
    .pool                   // Almacenar las constantes de código
    .endfunc
