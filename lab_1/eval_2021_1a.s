// Quevedo, Franco
// 39.733.942

    .cpu 	cortex-m4          // Indica el procesador de destino  
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

/* Definicion de variables globales ***************************************/

    .section .data           // Define la sección de variables (RAM)
vector:
    .byte  0x06,0x85,0x78,0xF8,0xE0,0x80       // Vector

/* Programa principal *****************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func	main            // Indica al depurador el inicio de una funcion

reset:
    LDR     R0,=vector      // Apunto R0 a vector (direccion base)

loop:
	LDRB 	R1,[R0]         // Guardo en R1 el 1er elemento de 'vector'
    MOV     R3,#1           // Uso R3 como mascara a desplazar
    MOV     R5,#0           // Contador de 1

    CMP     R1,0x80         // Verifico si es el final de vector (0x80)
    BEQ     stop

    BPL     conversion_Ca2  // Si N=0 (R1-0x80>=0) entonces es negativo -> lo convierto a Ca2

conversion_Ca2:
    AND     R4,R1,R3        // Guardo en R4 el resultado de R1 AND R3 (R1 AND 0x0000.0001)
    CMP     R4,#0           // Comparo si el resultado del AND es 0
    ITE     EQ              // > sin signo (C=1 and Z=0)
    LSLEQ   R3,#1           // Si es un 0 lo salteo y busco un 1 a la izq
    ADDNE   R5,#1           // Si es un 1 entonces incremento el contador
    BEQ     conversion_Ca2  // Verifico de vuelta

    CMP     R5,#1           // Si es el 1er 1 a la derecha lo salteo
    BEQ     conversion_Ca2  // Verifico de vuelta
    
    CMP     R4,#0           // Comparo si el resultado del AND es 0
    IT      HS
    ORRHS   R1,R3           // Si el bit es 0 lo cambio por 1
    IT      LO
    ANDLO   R1,R3           // Si el bit es 1 lo cambio por 0
    
    CMP     R3,#0x80        // Comparo si la mascara R3 ya se desplazo hasta 0x1000.0000
    BEQ     guardar_elemento
    LSL     R3,#1           // Desplazo la mascara 1 lugar a la izq (0000.0001 -> 0000.0010)
    B       conversion_Ca2
    
guardar_elemento:
    STRB    R1,[R0],#1      // Lo sobreescribo en la posicion de R0 en la que estaba
    B       loop

stop:
    B       stop            //Lazo infinito para detener

    .pool                   // Almacenar las constantes de código
    .endfunc
