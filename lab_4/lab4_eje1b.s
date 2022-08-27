    .cpu cortex-m4          // Indica el procesador de destino
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"

    /****************************************************************************/
    /* Definiciones de macros                                                   */
    /****************************************************************************/

    // Recursos utilizados por la primera tecla
    .equ BOTON_1_PORT,    4
    .equ BOTON_1_PIN,     8
    .equ BOTON_1_BIT,     12
    .equ BOTON_1_MASK,    (1 << BOTON_1_BIT)

    // Recursos utilizados por la segunda tecla
    .equ BOTON_2_PORT,    4
    .equ BOTON_2_PIN,     9
    .equ BOTON_2_BIT,     13
    .equ BOTON_2_MASK,    (1 << BOTON_2_BIT)

    // Recursos utilizados por el teclado
    .equ BOTON_GPIO,      5
    .equ BOTON_OFFSET,    ( BOTON_GPIO << 2 )
    .equ BOTON_MASK,      (BOTON_1_MASK | BOTON_2_MASK)

    // -------------------------------------------------------------------

    // Recursos del Segmento DP (punto) de los display 7 segmentos
    .equ SEG_DP_PORT,      6
    .equ SEG_DP_PIN,       8
    .equ SEG_DP_MAT,       1
    .equ SEG_DP_TMR,       2

    /****************************************************************************/
    /* Definicion de variables globales                                         */
    /****************************************************************************/

    .section .data          // Define la sección de variables (RAM)

factor:                     // Guarda factor de trabajo
    .byte 50
estado:
    .byte 0                 // Empieza prendido el led cuando entra a la primera int

    /****************************************************************************/
    /* Programa principal                                                       */
    /****************************************************************************/

    .global reset           // Define el punto de entrada del código
    .section .text          // Define la sección de código (FLASH)
    .func main              // Inidica al depurador el inicio de una funcion

reset:
    // Configura el pin del punto como salida TMAT
    LDR R1,=SCU_BASE
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC5)
    STR R0,[R1,#(SEG_DP_PORT << 7 | SEG_DP_PIN << 2)]

    // Configura los pines de las teclas como gpio con pull-up
    MOV R0,#(SCU_MODE_PULLUP | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    STR R0,[R1,#(BOTON_1_PORT << 7 | BOTON_1_PIN << 2)]
    STR R0,[R1,#(BOTON_2_PORT << 7 | BOTON_2_PIN << 2)]

    LDR R1,=GPIO_DIR0

    // Configura los bits GRPIO de los botones como entradas
    LDR R0,[R1,#BOTON_OFFSET]
    AND R0,#BOTON_MASK
    STR R0,[R1,#BOTON_OFFSET]

    // ----------------------------------------------------------------------------------

    // Cuenta con clock interno
    LDR R1,=TIMER2_BASE
    MOV R0,#0x00
    STR R0,[R1,#CTCR]

    // Prescaler de 9.500.000 para una frecuencia de 10 Hz
    LDR R0,=95000
    STR R0,[R1,#PR]

    // El valor del periodo para 1 Hz
    LDR R0,=1
    STR R0,[R1,#MR1]

    // El registro de match provoca reset del contador
    MOV R0,#(MR0R << (3 * SEG_DP_MAT))
    STR R0,[R1,#MCR]

    // Define el estado inicial y toggle on match del led
    MOV R0,#(3 << (4 + (2 * SEG_DP_MAT)))
    STR R0,[R1,#EMR]

    // Limpieza del contador
    MOV R0,#CRST
    STR R0,[R1,#TCR]

    // Inicio del contador
    MOV R0,#CEN
    STR R0,[R1,#TCR]

main:
    LDR  R0,[R6,#BOTON_OFFSET]      // Leo estado actual teclas
    
    LDR  R5,=BOTON_MASK             // Hago un not bit a bit pq las teclas son con pull up
    BIC  R0,R5,R0                   // y paso por la mascara para filtrar teclas

    LDR  R2,=factor
    LDRB R1,[R2]

tecla1:
    ANDS  R5,R0,#BOTON_1_MASK
    ITT   NE
    MOVNE R3,#0         // Actualiza estado
    BNE   tecla2        // Si no esta apretada que salte
    CMP   R3,#1
    BEQ   tecla2        // Si ya estaba apretada que salte
    MOV   R3,#1
    
    CMP   R1,#90
    BEQ   tecla2
    ADD   R1,#10       // Aumenta duty cycle
    STRB  R1,[R2]      // Actualiza el valor en memoria

tecla2:
    ANDS  R5,R0,#BOTON_2_MASK
    ITT   NE
    MOVNE R4,#0         // Actualiza estado
    BNE   main          // Si no esta apretada que salte
    CMP   R4,#1
    BEQ   main          // Si ya estaba apretada que salte
    MOV   R4,#1

    CMP   R1,#10
    BEQ   main
    SUB   R1,#10        // Disminuye duty cycle
    STRB  R1,[R2]       // Actualiza el valor en memoria

    B main

    .pool               // Almacenar las constantes de código
    .endfunc
