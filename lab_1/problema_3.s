    .cpu 	cortex-m4       // Indica el procesador de destino  
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

/* Definicion de variables globales ***************************************/

    .section .data           // Define la sección de variables (RAM)
@ cadena:
@     .ascii "SISTEMAS CON MICROPROCESADORES"
@     .byte   0x00
cadena_2:
    .byte   0x01,0x06,0x7A,0x7B,0x7C,0x00

/* Programa principal *****************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func	main              // Indica al depurador el inicio de una funcion

reset:
    @ LDR     R0,=cadena      // Apunto R0 a vector (direccion base)
    LDR     R0,=cadena_2      // Apunto R0 a vector (direccion base)
loop:
	LDRB 	R1,[R0]	        // Guardo en R1 el 1er caracter/elemento de la cadena y luego desplazo
    MOV     R2,#0           // Uso R2 como contador de la cant de 1
    MOV     R3,#1           // Uso R3 como mascara a desplazar
    CMP     R1,0x00         // Verifico si es el final de la cadena
    BEQ     stop

control_bitAbit:
    AND     R4,R1,R3        // Guardo en R4 el resultado de R1 AND R3 (R1 AND 0x00000001)
    LSL     R3,#1           // Desplazo la mascara 1 lugar a la izq (0001 -> 0010)
    CMP     R4,#0           // Comparo si el resultado del AND es 0
    IT      HI              // > sin signo (C=1 and Z=0)
    ADDHI   R2,#1           // Aumento en 1 el contador de 1s
    
    CMP     R3,#0x80        // Comparo si la mascara R3 ya se desplazo hasta 1000.0000
    BLS     control_bitAbit // Salto si menor o igual que 0X80 (C=0 o Z=1)

    LSRS    R2,#1           // El lsb de R2 me indica la paridad, lo saco por el carry(?)

    IT      HS              // >= sin signo (C=1)
    @ ADDHS   R1,0x80         // Si el msb es 0 lo cambio por 1 (0101 -> 1101)
    ORRHS   R1,0x80         // Si el msb es 0 lo cambio por 1 (0101 -> 1101)
    STRB    R1,[R0],#1      // Lo sobreescribo en el lugar de R0 en el que estaba
    B       loop

stop:
    B       stop            //Lazo infinito para detener

    .pool                   // Almacenar las constantes de código
    .endfunc
