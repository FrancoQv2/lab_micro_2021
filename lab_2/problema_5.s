    .cpu 	cortex-m4       // Indica el procesador de destino  
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

/* Definicion de variables globales ***************************************/
    .section .data          // Define la sección de variables (RAM)
segundos:
    .byte   8   // unidad
    .byte   5   // decena
minutos:
    .byte   3   // unidad
    .byte   4   // decena

/* Programa principal *****************************************************/
    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func	main            // Indica al depurador el inicio de una funcion
reset:
    LDR     R1,=segundos    // Apunto R1 al inicio de 'segundos'
incrementar_seg:
    MOV     R0,#1           // Para incrementar en 1 seg por defecto
    BL      incrementar
    CMP     R0,#1           // Controlo si hubo desborde de seg 
    BEQ     incrementar_min
    B       incrementar_seg
incrementar_min:
    LDR     R1,=minutos     // Apunto R1 al inicio de 'minutos'
    MOV     R0,#1           // Para incrementar en 1 seg por defecto
    BL      incrementar
stop:
    B       stop            // Lazo infinito para detener
    .pool                   // Almacenar las constantes de código
    .endfunc

/* 
    Rutina de incremento de segundos/minutos
    Recibe en R0 el valor a incrementar
    Recibe en R1 la direccion de los datos
*/
    .func   incrementar
incrementar:
    PUSH    {R4-R5}
    LDRB    R4,[R1]         // Busca el valor menos significativo
    ADD     R4,R0           // Se incrementa en R0 cantidad
    MOV     R0,#0           // Setea el valor de retorno por defecto
    CMP     R4,#9
    BLS     final_incrementar   // Salta si es menor o igual que 9
    SUB     R4,#9           // Calcula la cantidad que se desbordo
    LDRB    R5,[R1,#1]      // Busca el valor mas significativo
    ADD     R5,R4           // Se incrementa en la cantidad de desborde
    MOV     R4,#0           // Resetea el menos significatico
    CMP     R5,#5
    BLS     salto_incrementar   // Salta si es menor o igual que 5
    MOV     R5,#0           // Resetea el mas significativo
    MOV     R0,#1           // Setea el valor de retorno por desborde
salto_incrementar:
    STRB    R5,[R1,#1]      // Almacena el nuevo valor mas significativo
final_incrementar:
    STRB    R4,[R1]         // Almacena el nuevo valor menos significativo
    POP     {R4-R5}
    BX      LR              // Retorna al programa principal
    .pool                   // Almacenar las constantes de código

tabla_bcd:                  // Define la tabla de conversión (0gfedcba)
    .byte 0x3F,0x60,0x5B,0x4F,0x66      //0,1,2,3,4
    .byte 0x6D,0xCD,0x07,0x7F,0x6F      //5,6,7,8,9
    .byte 0x77,0x7F,0x39,0x3F,0x79,0x71 //A,B,C,D,E,F
    .endfunc
    