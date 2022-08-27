    .cpu 	cortex-m4       // Indica el procesador de destino  
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

/* Definicion de variables globales ***************************************/
    .section .data          // Define la sección de variables (RAM)

/* Programa principal *****************************************************/
    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func	main            // Indica al depurador el inicio de una funcion
reset:
    MOV     R0,#2           // Guardo en R0 el indice de la tecla apretada
    BL      teclas_handler
stop:
    B       stop            // Lazo infinito para detener
    .pool                   // Almacenar las constantes de código
    .endfunc
    
    .func   teclas_handler
teclas_handler:
    PUSH    {R4-R5}
    LDR     R4,=saltos      // Apunto R1 al inicio de la tabla de saltos
    ADD     R5,R4,R0,LSL #2     // Obtengo la direccion del elem con indice R2 de la tabla
    LDR     R0,[R5]         // Cargo la direccion a saltar en R0
    ADD     R0,#1           // Para que el bit 0 de sea 1 (instruccion Thumb)
    POP     {R4-R5}
    MOV     LR,R0
    BX      LR
    .pool
saltos:
    .word   0x1A001D05      // i=0
    .word   0x1A002321      // i=1
    .word   0x01A05FC4      // i=2
    .word   0x01A07C3A      // i=3
    .endfunc
