    .cpu 	cortex-m4       // Indica el procesador de destino  
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

/* Definicion de variables globales ***************************************/
    .section .data          // Define la sección de variables (RAM)
dividendo:
    .hword  20
divisor:
    .hword  3
resultado:
    .hword  0

/* Programa principal *****************************************************/
    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func	main            // Indica al depurador el inicio de una funcion
reset:
    LDR     R0,=dividendo   // Apunto R0 al dividendo
    LDR     R1,=divisor     // Apunto R1 al divisor
llamada_func:
    LDRH    R0,[R0]         // Cargo el dividendo en R0
    LDRH    R1,[R1]         // Cargo el divisor en R1
    BL      modulo
stop:
    B       stop            // Lazo infinito para detener
    .pool                   // Almacenar las constantes de código
    .endfunc
    
    .func   modulo          // uint16_t modulo(uint16_t dividendo, uint16_t divisor);
modulo:
    PUSH    {R4-R5}
    UDIV    R4,R0,R1
    MUL     R4,R4,R1
    SUB     R4,R0,R4
    LDR     R5,=resultado
    STRH    R4,[R5]
    POP     {R4-R5}
    BX      LR
    .pool
    .endfunc
