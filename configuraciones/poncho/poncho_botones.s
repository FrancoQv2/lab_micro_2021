/****************************************************************************/
/* Archivo con la configuracion para utilizar                               */
/* los botones del poncho                                                   */
/* de la EDU-CIAA                                                           */
/****************************************************************************/

    // PONCHO BOTONES -----------------------------------------------------------------------
    // Recursos utilizados por el 1er boton del poncho
    .equ BOTON_1_PORT,    4
    .equ BOTON_1_PIN,     8
    .equ BOTON_1_BIT,     12
    .equ BOTON_1_MASK,    (1 << BOTON_1_BIT)

    // Recursos utilizados por el 2do boton del poncho
    .equ BOTON_2_PORT,    4
    .equ BOTON_2_PIN,     9
    .equ BOTON_2_BIT,     13
    .equ BOTON_2_MASK,    (1 << BOTON_2_BIT)

    // Recursos utilizados por el 3er boton del poncho
    .equ BOTON_3_PORT,    4
    .equ BOTON_3_PIN,     10
    .equ BOTON_3_BIT,     14
    .equ BOTON_3_MASK,    (1 << BOTON_3_BIT)

    // Recursos utilizados por el 4to boton del poncho
    .equ BOTON_4_PORT,    6
    .equ BOTON_4_PIN,     7
    .equ BOTON_4_BIT,     15
    .equ BOTON_4_MASK,    (1 << BOTON_4_BIT)

    // Recursos utilizados por el boton ACEPTAR del poncho
    .equ BOTON_A_PORT,    3
    .equ BOTON_A_PIN,     1
    .equ BOTON_A_BIT,     8
    .equ BOTON_A_MASK,    (1 << BOTON_A_BIT)

    // Recursos utilizados por el boton CANCELAR del poncho
    .equ BOTON_C_PORT,    3
    .equ BOTON_C_PIN,     2
    .equ BOTON_C_BIT,     9
    .equ BOTON_C_MASK,    (1 << BOTON_C_BIT)

    // Recursos utilizados por los 4 botones del poncho
    .equ BOTON_GPIO,      5
    .equ BOTON_OFFSET,    ( BOTON_GPIO << 2 )
    .equ BOTON_MASK,      ( BOTON_1_MASK | BOTON_2_MASK | BOTON_3_MASK | BOTON_4_MASK | BOTON_A_MASK | BOTON_C_MASK )

    @ .equ TEC1, (TEC_GPIO << 5 | TEC_1_BIT)
    @ .equ TEC2, (TEC_GPIO << 5 | TEC_2_BIT)
    @ .equ TEC3, (TEC_GPIO << 5 | TEC_3_BIT)
    @ .equ TEC4, (TEC_GPIO << 5 | TEC_4_BIT)
    @ .equ TECA, (TEC_GPIO << 5 | TEC_A_BIT)
    @ .equ TECC, (TEC_GPIO << 5 | TEC_C_BIT)


/****************************************************************************/
/* Esto iría en el reset:                                                   */
/****************************************************************************/
/*
    // Configura los pines de los botones del poncho como GPIO c/pull-up F4
    @ MOV R0,#( SCU_MODE_INBUFF_EN | SCU_MODE_FUNC0)
    MOV R0,#(SCU_MODE_PULLDOWN | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    STR R0,[R1,#(BOTON_1_PORT << 7 | BOTON_1_PIN << 2)]     //P4_8
    STR R0,[R1,#(BOTON_2_PORT << 7 | BOTON_2_PIN << 2)]     //P4_9
    STR R0,[R1,#(BOTON_3_PORT << 7 | BOTON_3_PIN << 2)]     //P4_10
    STR R0,[R1,#(BOTON_4_PORT << 7 | BOTON_4_PIN << 2)]     //P6_7
    STR R0,[R1,#(BOTON_A_PORT << 7 | BOTON_A_PIN << 2)]     //P3_1
    STR R0,[R1,#(BOTON_C_PORT << 7 | BOTON_C_PIN << 2)]     //P3_2

    // Configuro los bits GPIO de las teclas como entradas
    LDR R0,[R1,#BOTON_OFFSET]
    BIC R0,#BOTON_MASK
    STR R0,[R1,#BOTON_OFFSET]

*/
