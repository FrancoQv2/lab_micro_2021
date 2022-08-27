// Quevedo, Franco
// 39.733.942

    .cpu 	cortex-m4       // Indica el procesador de destino  
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

/* Definicion de variables globales ***************************************/

    .section .data          // Define la sección de variables (RAM)
numero:
    .byte   29

/* Programa principal *****************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func	main            // Indica al depurador el inicio de una funcion
reset:
    LDR     R0,=numero
    LDRB    R0,[R0]
    BL      segmentos
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
