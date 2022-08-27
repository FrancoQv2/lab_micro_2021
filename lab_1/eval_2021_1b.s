// Quevedo, Franco
// 39.733.942

    .cpu 	cortex-m4       // Indica el procesador de destino  
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

/* Definicion de variables globales ***************************************/

    .section .data          // Define la sección de variables (RAM)
vector:
    .byte  0x06,0x85,0x78,0xF8,0xE0,0x80       // Vector

/* Programa principal *****************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func	main            // Indica al depurador el inicio de una funcion

reset:
    LDR     R0,=vector      // Apunto R0 al inicio de 'vector' (direccion base)
    MOV     R1,#0           // Contador en R3 para cantidad de negativos
    LDR     R2,=tabla       // Apunta R2 al bloque con la tabla
    
loop:
    LDRB    R3,[R0],#1      // Cargo en R3 el 1er elemento del vector y luego desplazo 1 lugar
    CMP     R3,0x80         // Verifico si el elemento actual es el 0x80
    BEQ     final
    IT      PL
    ADDPL   R1,#1           // Si N=0 (R1-0x80>=0) entonces es negativo, aumento R1
    B       loop

final:
    LDRB    R1,[R2,R1]      // Cargo en R1 el elemento convertido con la tabla y luego desplazo 1 lugar

stop:
    B       stop            //Lazo infinito para detener

    .pool                   // Almacenar las constantes de código

tabla:                      // Define la tabla de conversión (0gfedcba)
    .byte 0x3F,0x60,0x5B,0x4F,0x66      //0,1,2,3,4
    .byte 0x6D,0xCD,0x07,0x7F,0x6F      //5,6,7,8,9
    .byte 0x77,0x7F,0x39,0x3F,0x79,0x71 //A,B,C,D,E,F
    .endfunc
