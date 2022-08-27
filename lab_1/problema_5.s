    .cpu 	cortex-m4       // Indica el procesador de destino  
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

/* Definicion de variables globales ***************************************/

    .section .data          // Define la sección de variables (RAM)
resultado:
    .byte   0x00            // 1er byte para el resultado
datos:
    .byte   0x03,0x3A,0xAA,0xF2,0x11

/* Programa principal *****************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func	main            // Indica al depurador el inicio de una funcion

reset:
    LDR     R0,=resultado   // Apunto R0 al inicio de 'datos' (direccion base)
    LDR     R1,=datos       // Apunto R0 al inicio de 'datos' (direccion base)
    LDRB    R2,[R1]         // Guardo en R2 el resultado temporal (1er elemento en base+1)
    MOV     R4,#1           // Contador para recorrer 'datos'
loop:
    CMP     R4,#4           // Detengo si se llego al final del 'datos'
    BEQ     stop
    ADD     R4,#1           // Incremento en 1 el contador
    LDRB    R3,[R1,#1]!     // Apunto R3 al siguiente elemento del bloque (direccion base+2)
    CMP     R3,R2           // Comparo el actual más grande R2 contra el elemento en R3
    IT      HS              // Entra si R3>=R2 (C=1)
    MOVHS   R2,R3           // Muevo el nuevo más grande a R2
    B       loop

stop:
    STRB    R2,[R0]         // Finalmente guardo el elemento más grande en &resultado (direccion base)
    B       stop            // Lazo infinito para detener

    .pool                   // Almacenar las constantes de código
    .endfunc
