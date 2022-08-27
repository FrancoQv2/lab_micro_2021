/****************************************************************************/
/* Archivo con la configuracion para utilizar                               */
/* los botones del poncho                                                   */
/* de la EDU-CIAA                                                           */
/****************************************************************************/

// PONCHO DIGITOS 7 SEGMENTOS -------------------------------------------------------------------------
    .equ DIG_1_PORT,    0
    .equ DIG_1_PIN,     0
    .equ DIG_1_BIT,     0
    .equ DIG_1_MASK,    (1 << DIG_1_BIT)
    
    .equ DIG_2_PORT,    0
    .equ DIG_2_PIN,     1
    .equ DIG_2_BIT,     1
    .equ DIG_2_MASK,    (1 << DIG_2_BIT)
    
    .equ DIG_3_PORT,    1
    .equ DIG_3_PIN,     15
    .equ DIG_3_BIT,     2
    .equ DIG_3_MASK,    (1 << DIG_3_BIT)
    
    .equ DIG_4_PORT,    1
    .equ DIG_4_PIN,     17
    .equ DIG_4_BIT,     3
    .equ DIG_4_MASK,    (1 << DIG_4_BIT)

    // Recursos utilizados por TODOS los segmentos
    .equ DIG_GPIO,      0
    .equ DIG_OFFSET,    ( DIG_GPIO << 2 )
    .equ DIG_MASK,      ( DIG_1_MASK | DIG_2_MASK | DIG_3_MASK | DIG_4_MASK )


/****************************************************************************/
/* Esto iría en el reset:                                                   */
/****************************************************************************/
/*
    // Configura los segmentos de los DIGITOS del poncho como GPIO s/pull-up F0
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(DIG_1_PORT << 7 | DIG_1_PIN << 2)]     //P0_0
    STR R0,[R1,#(DIG_2_PORT << 7 | DIG_2_PIN << 2)]     //P0_1
    STR R0,[R1,#(DIG_3_PORT << 7 | DIG_3_PIN << 2)]     //P1_15
    STR R0,[R1,#(DIG_4_PORT << 7 | DIG_4_PIN << 2)]     //P1_17

    LDR R1,=GPIO_CLR0
    // Se apagan los bits GPIO de los Digitos
    LDR R0,=DIG_MASK
    STR R0,[R1,#DIG_OFFSET]

    LDR R1,=GPIO_DIR0
    // Configuro los bits GPIO de los Digitos como salidas
    LDR R0,=DIG_MASK
    STR R0,[R1,#DIG_OFFSET]

    // Dejo prendidos todos los digitos
    MOV     R3,#0x00                // Define el estado actual de los digitos como todos apagados
    ORR     R3,#DIG_1_MASK          // Enciende el bit del Digito 4
    STR     R3,[R4,#DIG_OFFSET]     // Actualiza las salidas con el estado definido para los digitos

*/

    .func digitos_config
digitos_config:
    // Configura los segmentos de los DIGITOS del poncho como GPIO s/pull-up F0
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(DIG_1_PORT << 7 | DIG_1_PIN << 2)]     //P0_0
    STR R0,[R1,#(DIG_2_PORT << 7 | DIG_2_PIN << 2)]     //P0_1
    STR R0,[R1,#(DIG_3_PORT << 7 | DIG_3_PIN << 2)]     //P1_15
    STR R0,[R1,#(DIG_4_PORT << 7 | DIG_4_PIN << 2)]     //P1_17
    BX  LR
    .endfunc
