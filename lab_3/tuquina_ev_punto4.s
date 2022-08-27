/*
    Nombre: Fernando Nahuel
    Apellido: Tuquina
    DNI: 39975251
 */

        .cpu cortex-m4                  // Indica el procesador de destino
        .syntax unified                 // Habilita las instrucciones Thumb - 2
        .thumb                          // Usar instrucciones Thumb y no ARM

/*************************************************************************/
/*              Definición de variables globales                         */
/*************************************************************************/

        .section .data                  // Define la sección de variables (RAM)   

        fechaActual:
            .byte 0x1D                  // Día en fecha
            .byte 0x09                  // Mes en Fecha+1 

        destino:
            .space 4                    // Resultado de conversión 
     
/*************************************************************************/
/*                          Programa Principal                           */
/*************************************************************************/

        .section .text                  //  Define la sección de código (FLASH)
        .global reset                   //  Define el punto de entrada del código
        .func main                      //  Indica al depurador el inicio de una función

reset:
        LDR     R0, =fechaActual        //  Guardo la dirección de fechaActual
        LDR     R1, =destino            //  Dirección de resultado
        BL      fecha
comienzo:
        MOV     R1, #0x08               //  Guardo la constante 0x08 en R1
        MOV     R4, #0                  //  Índice de posición
repetir:
        LDR     R2, =destino            //  Dirección de resultado        
        LDRB    R0, [R2, R4]            //  Cargo el primer dígito
        BL      mostrar                 //  Llamo a la subrutina mostrar
        BL      demora                  //  Llamo a la subrutina demora
        ADD     R4, #1                  //  Incremento el índice
        LSR     R1, #1                  //  Divido en 2 a R1
        CMP     R4, #4                  //  Controlo si ya pasé por todos los displays
        BLO     repetir
        B       comienzo                //  Repito el código
        B       stop

/*---------------------------------------------------------------------------------- */

fecha:  
        PUSH    {LR}                    //  Guardo LR
        PUSH    {R4}                     
        BL      conversion              //  Llamo a la subrutina conversión
        ADD     R0,#1                   //  Incremento R0 para leer los meses
        ADD     R1,#2                   //  Incremento R1 para guardar los datos de los meses
        BL      conversion
        LDR     R1, =destino            //  R1 vuelve a apuntar a R1
        MOV     R4, #0                  //  Uso R4 como contador

lazo:           
        LDRB    R0, [R1, R4]            //  Guardo el primer dígito de fecha
        BL      segmentos               //  Llamo a la subrutina segmentos
        STRB    R0, [R1, R4]            //  Guardo el código BCD del dígito en destino
        ADD     R4, #1                  //  Incremento el contador
        CMP     R4, #4                  //  Controlo si ya cargó todos los segmentos
        BLO     lazo
        POP     {R4}
        POP     {PC}

/*---------------------------------------------------------------------------------- */

conversion:
        PUSH    {R4,R5,R6,R7}           //  Guardo los registros que usaré en la pila
        LDRB    R4, [R0]                //  Guardo el número en R4
        MOV     R5, R4                  //  Muevo R4 a R5
        MOV     R6, #0                  //  Uso R6 como contador de las decenas

restasSucesivas:   
        SUB     R5, #10                 //  Resto 10 al número
        CMP     R5, #0                  //  Comparo R5 con cero
        BLT     final
        ADD     R6, #1                  //  Incremento contador en 1
        B       restasSucesivas

final:
        MOV     R7, #10                 //  Uso R7 como constante para usar la instrucción MUL
        MUL     R5, R6, R7              //  Guardo las decenas en R5
        SUB     R4, R5                  //  Guardo las unidades de R4
        STRB    R6, [R1]                //  Cargo las decenas en destino
        STRB    R4, [R1, #1]            //  Cargo las unidades en destino+1
        POP     {R4,R5,R6,R7}
        BX      LR

/*---------------------------------------------------------------------------------- */

segmentos:
        PUSH    {R4}                    //  Guardo en la pila R4
        LDR     R4, =tabla              //  Apunta R4 al bloque con la tabla
        LDRB    R0,[R4, R0]             //  Carga en R0 el elemento convertido
        POP     {R4}                    //  Saco el dato de la pila
        BX      LR

/*---------------------------------------------------------------------------------- */

stop:   B       stop                    //  Lazo infinito para terminar la ejecución
        .pool                           //  Almacenar las constantes de código

tabla:
        .byte 0x3F, 0x06, 0x5B, 0x4F, 0x66
        .byte 0x6D, 0x7D, 0x07, 0x7F, 0x6F
        .endfunc

/****************************************************************************/
/* Inclusion de la librería con las funciones
/****************************************************************************/

.include "Laboratorios/Lab2/Evaluativo/funciones.s"
