    .cpu    cortex-m4           // Indica el procesador de destino  
    .syntax unified             // Habilita las instrucciones Thumb-2
    .thumb                      // Usar instrucciones Thumb y no ARM

/* Definicion de variables globales ***************************************/

    .section .data          // Define la sección de variables (RAM) 
destino:    
    .byte   0x00           // Direccion del digito 7 seg

/* Programa principal *****************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func   main            // Indica al depurador el inicio de una funcion

reset:
    MOV     R0,#3           // Cargo el 1er digito en R0
    MOV     R1,#7           // Cargo el 2do digito en R1
    LDR     R2,=destino     // Apunta R2 al inicio de 'destino'
    LDR     R3,=tabla       // Apunta R3 al bloque con la tabla
    LDR     R6,#0           // Contador para las iteraciones

convertir_unidad:
    LDRB    R4,[R3,R0]         // Cargar en R4 el elemento convertido (unidad)
    STRB    R4,[R2]            // Guardar el elemento convertido

delay:
    CMP     R6,#100000         // Determina si es el fin de conversión
    BEQ     convertir_decena
    ADD     R6,#1              // Aumento en 1 el contador
    B       delay              // Repetir el lazo de conversión

convertir_decena:
    LDRB    R4,[R3,R1]         // Cargar en R4 el elemento convertido (decena)
    STRB    R4,[R2]            // Guardar el elemento convertido

stop:
    B       stop               // Lazo infinito para terminar la ejecución

    .pool                   // Almacenar las constantes de código

tabla:                      // Define la tabla de conversión (0gfedcba)
    .byte 0x3F,0x60,0x5B,0x4F,0x66      //0,1,2,3,4
    .byte 0x6D,0xCD,0x07,0x7F,0x6F      //5,6,7,8,9
    .byte 0x77,0x7F,0x39,0x3F,0x79,0x71 //A,B,C,D,E,F    
    .endfunc
