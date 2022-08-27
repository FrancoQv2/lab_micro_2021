    .cpu 	cortex-m4       // Indica el procesador de destino  
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

/* Definicion de variables globales ***************************************/

    .section .data          // Define la sección de variables (RAM)
vector:
    .byte   0xA7,0x7B,0x64
resultado:
    .space  4,0x00

/* Programa principal *****************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func	main            // Indica al depurador el inicio de una funcion
reset:
    LDR     R4,=vector
    LDR     R5,=resultado
    BL      codif_MIME
stop:
    B       stop            // Lazo infinito para detener

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

tabla:
    .ascii  "ABCDE..Zabcde..z012..9+/"
    .endfunc
