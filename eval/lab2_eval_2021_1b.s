// Quevedo, Franco
// 39.733.942

    .cpu 	cortex-m4       // Indica el procesador de destino  
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

/* Definicion de variables globales ***************************************/

    .section .data          // Define la sección de variables (RAM)
numero:
    .byte   29
resultado:
    .space  2,0

/* Programa principal *****************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func	main            // Indica al depurador el inicio de una funcion
reset:
    LDR     R0,=numero
    LDR     R1,=resultado
    BL      conversion
stop:
    B       stop            // Lazo infinito para detener

    .pool                   // Almacenar las constantes de código
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
    STRB    R6,[R1,#1]      // Guardo la unidad en base+1
    POP     {R4-R7}
    BX      LR
    .pool                   // Almacenar las constantes de código
    .endfunc
