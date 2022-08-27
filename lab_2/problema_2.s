    .cpu 	cortex-m4       // Indica el procesador de destino  
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

/* Definicion de variables globales ***************************************/

    .section .data          // Define la sección de variables (RAM)
numero64:                   // Numero de 64 bits
    .word   0x81000304
    .word   0x00200605

/* Programa principal *****************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func	main            // Indica al depurador el inicio de una funcion

reset:
    LDR     R0,=numero64    // Apunto R0 al inicio de 'numero64' (direccion base)
    MOV     R1,#0x0102      // Cargo la parte baja del num de 32 bits (0xA056.0102)
    MOVT    R1,#0xA056      // Cargo la parte alta
    BL      suma64          // Llamo por parametros a la funcion suma64

stop:
    B       stop            //Lazo infinito para detener

/* 
    Funcion Sum64
    Suma dos numeros, uno de 64 bits y uno de 32 bits
    R0: puntero al numero de 64 bits
    R1: numero de 32 bits
*/
suma64:
    LDR     R4,[R0]         // Cargo en R4 los 32 bits mas bajos
    LDR     R5,[R0,#4]      // Cargo en R5 los 32 bits mas altos
    ADDS    R4,R4,R1        // Sumo con carry los 32 bits mas bajos con R1
    ADC     R5,#0           // Sumo con carry los 32 bits mas altos con el carry
    STR     R4,[R0]         // Guardo los 32 bits mas bajos en base
    STR     R5,[R0,#4]      // Guardo los 32 bits mas altos en base+4
    BX      LR

    .pool                   // Almacenar las constantes de código
    .endfunc
