    .cpu 	cortex-m4       // Indica el procesador de destino  
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

/* Definicion de variables globales ***************************************/

    .section .data          // Define la sección de variables (RAM)
vector:
    .byte   0x03,0x3A,0xF2,0x11,0x3B,0x7A,0xF1,0x00
resultado:
    .space  4,0x00

/* Programa principal *****************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func	main            // Indica al depurador el inicio de una funcion

reset:
    LDR     R0,=vector      // Apunto R0 al inicio de 'vector' (direccion base)
    MOV     R2,#0           // Contador en R2 para cantidad de pares
    MOV     R3,#0           // Contador en R3 para cantidad de impares
    MOV     R5,#0           // Contador en R5 para cantidad de negativos
    MOV     R6,#0           // Contador en R6 para cantidad de positivos

loop:
    LDRB    R1,[R0],#1      // Cargo en R1 el 1er elemento del vector y luego desplazo 1 lugar
    CMP     R1,0x00         // Verifico si el elemento actual es el 0x00
    BEQ     final

control_signo:
    CMP     R1,0x80         // Comparo con 0x80 (1000.0000)
    ITE     PL
    ADDPL   R5,#1           // Si N=0 (R1-0x80>=0) entonces es negativo, aumento R5
    ADDMI   R6,#1           // Si N=1 (R1-0x80<0) entonces es positivo, aumento R6

control_paridad:
    AND     R4,R1,0x01      // 0x01 mascara para saber si es impar
    CMP     R4,0x00         // Comparo si el resultado del AND es 1 (par)
    ITE     HI
    ADDHI   R3,#1           // Si C=1 and Z=0 entonces es impar, aumento R3
    ADDLS   R2,#1           // SI C=0 and Z=1 entonces es par, aumento R2
    B       loop

final:
    LDR     R0,=resultado   // Apunto R0 al inicio de 'resultado' (direccion resultado)
    STRB    R2,[R0]         // Guardo la cantidad de pares en la direccion resultado
    STRB    R3,[R0,#1]      // Guardo la cantidad de impares en la direccion resultado+1
    STRB    R5,[R0,#2]      // Guardo la cantidad de positivos en la direccion resultado+2
    STRB    R6,[R0,#3]      // Guardo la cantidad de negativos en la direccion resultado+3
stop:
    B       stop            //Lazo infinito para detener

    .pool                   // Almacenar las constantes de código
    .endfunc
