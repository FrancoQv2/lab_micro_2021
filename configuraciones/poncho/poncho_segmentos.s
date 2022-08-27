/****************************************************************************/
/* Archivo con la configuracion para utilizar                               */
/* los botones del poncho                                                   */
/* de la EDU-CIAA                                                           */
/****************************************************************************/

    // PONCHO 7 SEGMENTOS -------------------------------------------------------------------------
    // Segmento A de los display 7 segmentos
    .equ SEG_A_PORT,    4
    .equ SEG_A_PIN,     0
    .equ SEG_A_BIT,     0
    .equ SEG_A_MASK,    (1 << SEG_A_BIT)
    
    // Segmento B de los display 7 segmentos (vertical)
    .equ SEG_B_PORT,    4
    .equ SEG_B_PIN,     1
    .equ SEG_B_BIT,     1
    .equ SEG_B_MASK,    (1 << SEG_B_BIT)
    
    // Segmento C de los display 7 segmentos (vertical)
    .equ SEG_C_PORT,    4
    .equ SEG_C_PIN,     2
    .equ SEG_C_BIT,     2
    .equ SEG_C_MASK,    (1 << SEG_C_BIT)
    
    // Segmento D de los display 7 segmentos
    .equ SEG_D_PORT,    4
    .equ SEG_D_PIN,     3
    .equ SEG_D_BIT,     3
    .equ SEG_D_MASK,    (1 << SEG_D_BIT)
    
    // Segmento E de los display 7 segmentos (vertical)
    .equ SEG_E_PORT,    4
    .equ SEG_E_PIN,     4
    .equ SEG_E_BIT,     4
    .equ SEG_E_MASK,    (1 << SEG_E_BIT)
    
    // Segmento F de los display 7 segmentos (vertical)
    .equ SEG_F_PORT,    4
    .equ SEG_F_PIN,     5
    .equ SEG_F_BIT,     5
    .equ SEG_F_MASK,    (1 << SEG_F_BIT)
    
    // Segmento G de los display 7 segmentos
    .equ SEG_G_PORT,    4
    .equ SEG_G_PIN,     6
    .equ SEG_G_BIT,     6
    .equ SEG_G_MASK,    (1 << SEG_G_BIT)

    // Recursos utilizados por TODOS los segmentos
    .equ SEG_GPIO,      2
    .equ SEG_OFFSET,    ( SEG_GPIO << 2 )
    .equ SEG_MASK,      ( SEG_A_MASK | SEG_B_MASK | SEG_C_MASK | SEG_D_MASK | SEG_E_MASK | SEG_F_MASK | SEG_G_MASK )

    // Segmento DP (el punto) de los display 7 segmentos
    .equ SEG_DP_PORT,    6
    .equ SEG_DP_PIN,     8
    .equ SEG_DP_BIT,     16
    .equ SEG_DP_MASK,    (1 << SEG_DP_BIT)

    .equ SEG_DP_GPIO,    5
    .equ SEG_DP_OFFSET,  (SEG_DP_GPIO << 2)

/****************************************************************************/
/* Esto iría en el reset:                                                   */
/****************************************************************************/
/*
    // Configura los segmentos de los 7 segmentos del poncho como GPIO s/pull-up F0
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(SEG_A_PORT << 7 | SEG_A_PIN << 2)]     //P4_0
    STR R0,[R1,#(SEG_B_PORT << 7 | SEG_B_PIN << 2)]     //P4_1
    STR R0,[R1,#(SEG_C_PORT << 7 | SEG_C_PIN << 2)]     //P4_2
    STR R0,[R1,#(SEG_D_PORT << 7 | SEG_D_PIN << 2)]     //P4_3
    STR R0,[R1,#(SEG_E_PORT << 7 | SEG_E_PIN << 2)]     //P4_4
    STR R0,[R1,#(SEG_F_PORT << 7 | SEG_F_PIN << 2)]     //P4_5
    STR R0,[R1,#(SEG_G_PORT << 7 | SEG_G_PIN << 2)]     //P4_6
    STR R0,[R1,#(SEG_DP_PORT << 7 | SEG_DP_PIN << 2)]   //P6_8

    LDR R1,=GPIO_CLR0
    // Se apagan los bits GPIO de los segmentos B,C,E,F
    LDR R0,=SEG_MASK
    STR R0,[R1,#SEG_OFFSET]

    LDR R1,=GPIO_DIR0
    // Configuro los bits GPIO de los segmentos B,C,E,F como salidas
    LDR R0,=SEG_MASK
    STR R0,[R1,#SEG_OFFSET]

    

*/

    .func segmentos_config
segmentos_config:
    // Configura los segmentos de los 7 segmentos del poncho como GPIO s/pull-up F0
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(SEG_A_PORT << 7 | SEG_A_PIN << 2)]     //P4_0
    STR R0,[R1,#(SEG_B_PORT << 7 | SEG_B_PIN << 2)]     //P4_1
    STR R0,[R1,#(SEG_C_PORT << 7 | SEG_C_PIN << 2)]     //P4_2
    STR R0,[R1,#(SEG_D_PORT << 7 | SEG_D_PIN << 2)]     //P4_3
    STR R0,[R1,#(SEG_E_PORT << 7 | SEG_E_PIN << 2)]     //P4_4
    STR R0,[R1,#(SEG_F_PORT << 7 | SEG_F_PIN << 2)]     //P4_5
    STR R0,[R1,#(SEG_G_PORT << 7 | SEG_G_PIN << 2)]     //P4_6
    STR R0,[R1,#(SEG_DP_PORT << 7 | SEG_DP_PIN << 2)]   //P6_8
    BX  LR
    .endfunc
