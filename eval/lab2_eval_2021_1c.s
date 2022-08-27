// Quevedo, Franco
// 39.733.942

    .cpu 	cortex-m4       // Indica el procesador de destino  
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

/* Definicion de variables globales ***************************************/

    .section .data          // Define la sección de variables (RAM)
fecha_actual:
    .byte   29              // dia
    .byte    9              // mes
resultado:
    .space  4,0x00

/* Programa principal *****************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func	main            // Indica al depurador el inicio de una funcion
reset:
    LDR     R0,=fecha_actual
    LDR     R1,=resultado
    BL      fecha
stop:
    B       stop            // Lazo infinito para detener

    .pool                   // Almacenar las constantes de código
    .endfunc

/* 
    Subrutina para convertir un numero (0~F) a BCD
    Recibe en R0 el numero a convetir
    Retorna en R0 el numero convertido a BCD
*/
    .func	segmentos
segmentos:
    PUSH    {R4}
    LDR     R4,=tabla
    LDRB    R0,[R4,R0]      // Cargo en R0 el elemento convertido con la tabla
    POP     {R4}
    BX      LR
    .pool                   // Almacenar las constantes de código

tabla:                      // Define la tabla de conversión (0gfedcba)
    .byte 0x3F,0x60,0x5B,0x4F,0x66      //0,1,2,3,4
    .byte 0x6D,0xCD,0x07,0x7F,0x6F      //5,6,7,8,9
    .byte 0x77,0x7F,0x39,0x3F,0x79,0x71 //A,B,C,D,E,F
    .endfunc

/* 
    Subrutina para guardar como bytes las decenas y unidades de un numero
    Recibe en R0 la direccion del numero a descomprimir
    Recibe en R1 la direccion donde guardar el resultado
*/
    .func	conversion
conversion:
    PUSH    {R4-R7}
    LDRB    R4,[R0]         // Cargo el numero en R4
    MOV     R7,#10

    UDIV    R5,R4,R7        // R5 tiene la decena
    MUL     R6,R5,R7
    SUB     R4,R6           // R6 tiene la unidad

    STRB    R5,[R1]         // Guardo la decena en base
    STRB    R4,[R1,#1]      // Guardo la unidad en base+1
    POP     {R4-R7}
    BX      LR
    .pool                   // Almacenar las constantes de código
    .endfunc

/* 
    Subrutina para convertir una fecha a BCD y guardarla donde corresponde
    Recibe en R0 la direccion de la fecha actual
    Recibe en R1 la direccion de destino para la conversion
*/
    .func	fecha
fecha:
    PUSH    {LR}
    PUSH    {R8}
    MOV     R8,R0           // Guardo la direccion base del numero
    BL      conversion      // Convierto el numero y lo guardo en 2 bytes de destino
    LDRB    R0,[R1]         // Cargo la decena (1er byte) y desplazo
    BL      segmentos
    STRB    R0,[R1]         // Guardo la decena en destino
    LDRB    R0,[R1,#1]      // Cargo la unidad (2do byte) y desplazo
    BL      segmentos
    STRB    R0,[R1,#1]      // Guardo la unidad en destino

    ADD     R0,R8,#1        // Cargo en R0 la direccion base+1 del numero
    ADD     R1,#2
    BL      conversion      // Convierto el numero y lo guardo en 2 bytes de destino
    LDRB    R0,[R1]         // Cargo la decena (1er byte) y desplazo
    BL      segmentos
    STRB    R0,[R1]         // Guardo la decena en destino
    LDRB    R0,[R1,#1]      // Cargo la unidad (2do byte) y desplazo
    BL      segmentos
    STRB    R0,[R1,#1]      // Guardo la unidad en destino

    POP     {R8}
    POP     {PC}
    .pool                   // Almacenar las constantes de código
    .endfunc
