    .cpu 	cortex-m4       // Indica el procesador de destino  
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

/* Definicion de variables globales ***************************************/

    .section .data          // Define la sección de variables (RAM)
divisor:
    .hword  999             // Media palabra (1 byte no alcanza)
segundos:
    .byte   0x09            // segundos[0] - unidad
    .byte   0x05            // segundos[1] - decena
hora:
    .byte   0x09            // hora[0] -> minutos[0] - unidad
    .byte   0x05            // hora[1] -> minutos[1] - decena
    .byte   0x09            // hora[2] - unidad
    .byte   0x01            // hora[3] - decena

    // Para probar cargo el valor correspondiente a la hora en memoria     

/* Programa principal *****************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func	main              // Indica al depurador el inicio de una funcion

reset:
    LDR     R0,=divisor         // Guardo la dirección del divisor
    LDR     R1,=segundos        // Guardo la dirección de los segundos
    LDR     R2,=hora            // Guardo la dirección de la hora
    LDRH    R3,[R0]             // Guardo el valor del divisor en R3
    ADD     R3,#1               // Incremento en 1 el divisor
    CMP     R3,#1000            // Controlo si el divisor llegó a 1000
    @ BLO     stop
    BEQ     stop
    MOV     R3,#0               // Hago cero el divisor
    LDRB    R4,[R1]             // Guardo segundos[0] en R4
    ADD     R4,#1               // Incremento segundos[0] en 1
bloque1:
    STRH    R3,[R0]             // Guardo el divisor en memoria
    LDRB    R0,[R1,#1]          // Guardo segundos[1] en R0
    CMP     R4,#9               // segundos[0] > 9? 
    BLS     bloque2
    MOV     R4,#0               // Hago cero a segundos[0]
    ADD     R0,#1               // Incremento segundos[1] en 1
bloque2:        
    STRB    R4,[R1]             // Guardo segundos[0] en memoria
    LDRB    R3,[R2]             // Guardo hora[0] en R3
    CMP     R0,#5               // segundos[1] > 5?
    BLS     bloque3 
    MOV     R0,#0               // Hago cero a segundos[1]
    ADD     R3,#1               // Incremento hora[0] en 1
bloque3:
    STRB    R0,[R1,#1]          // Guardo segundos[1] en memoria
    LDRB    R0,[R2,#1]          // Guardo hora[1] en R0
    CMP     R3,#9               // hora[0] > 9? (minutos[0])
    BLS     bloque4
    MOV     R3,#0               // Hago cero a hora[0]        
    ADD     R0,#1               // Incremento hora[1] en 1
bloque4:
    STRB    R3,[R2]             // Guardo hora[0] en memoria
    LDRB    R3,[R2,#2]          // Guardo hora[2] en R3
    CMP     R0,#5               // hora[1] > 5? (minutos[1])
    BLS     bloque5
    MOV     R0,#0               // Hago cero a hora[1]
    ADD     R3,#1               // Incremento hora[2] en 1
bloque5:
    STRB    R0,[R2,#1]          // Guardo hora[1] en memoria
    LDRB    R4,[R2,#3]          // Guardo hora[3] en R4
    CMP     R4,#2               // hora[3] = 2?
    BNE     bloque6
    CMP     R3,#3               // hora[2] > 3? 
    BLS     bloque6
    MOV     R3,#0               // Hago 0 a hora[2]
    MOV     R4,#0               // Hago 0 a hora[3]
    B       bloque7
bloque6:
    CMP     R3,#9               // hora[2] > 9? (hora unidad)
    BLS     bloque7         
    MOV     R3,#0               // Hago cero a hora[2]
    ADD     R4,#1               // Incremento hora[1] en 1
bloque7:
    STRB    R3,[R2,#2]          // Guardo hora[2] en memoria
    STRB    R4,[R2,#3]          // Guardo hora[3] en memoria
stop:  
    B       stop                // Lazo infinito para terminar la ejecución

    .pool                       // Almacenar las constantes de código
    .endfunc
