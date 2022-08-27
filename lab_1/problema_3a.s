    .cpu cortex-m4          // Indica el procesador de destino  
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

/* Definicion de variables globales ***************************************/

    .section .data           // Define la sección de variables (RAM)
cadena:
    .byte   0x06,0x7A,0x7B,0x7C,0x00
    .space  11,0x00
destino:
    .space  5,0x11
    .space  11,0x00

/* Programa principal *****************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func   main            // Indica al depurador el inicio de una funcion

reset:
    LDR     R0,=cadena          // Apunto R0 a la direccion base de cadena
    LDR     R1,=destino         // Apunto R1 a la direccino base de destino
    LDR     R2,=tabla_impar     // Apunto R2 a la direccino base de tabla_impar
    MOV     R3,#0               // Uso R3 como contador
loop:
    @ LDRB    R0,[R0],#1          // Cargo en R0 el primer valor de cadena y luego desplazo
    CMP     R0,0x00             // Comparo si es el final de la cadena
    @ ITE     EQ
    BEQ     stop                // Salto al final del prog
    @ BNE     loop
    @ B       control             // Si no es el final salto a control

@ control:
    @ LDRB    R2,[R2],#1          // Cargo en R2 el primer valor de tabla_impar y luego desplazo
    @ CMP     R0,R2               // Si el carácter no es igual a 0
    @ BEQ     loop

stop:
    B       stop                //Lazo infinito para detener
    .align
    .pool                       // Almacenar las constantes de código

tabla_impar:
    .byte 0x1,0x2,0x4,0x7,0x8,0xB,0xD,0xE
tabla_par:
    .byte 0x3,0x5,0x6,0x9,0xA,0xC,0xF
    
    .endfunc
