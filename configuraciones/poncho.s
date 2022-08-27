// Quevedo, Franco
// 39.733.942

/****************************************************************************/
/* Macros para acceso simbolico a los recursos del poncho de la edu-ciaa-nxp
/****************************************************************************/

// Recursos utilizados por el 1er Digito
    .equ DIG_1_PORT,    0
    .equ DIG_1_PIN,     0
    .equ DIG_1_BIT,     0
    .equ DIG_1_MASK,    (1 << DIG_1_BIT)
    
// Recursos utilizados por el 2do Digito
    .equ DIG_2_PORT,    0
    .equ DIG_2_PIN,     1
    .equ DIG_2_BIT,     1
    .equ DIG_2_MASK,    (1 << DIG_2_BIT)
    
// Recursos utilizados por el 3er Digito
    .equ DIG_3_PORT,    1
    .equ DIG_3_PIN,     15
    .equ DIG_3_BIT,     2
    .equ DIG_3_MASK,    (1 << DIG_3_BIT)
    
// Recursos utilizados por el 4to Digito
    .equ DIG_4_PORT,    1
    .equ DIG_4_PIN,     17
    .equ DIG_4_BIT,     3
    .equ DIG_4_MASK,    (1 << DIG_4_BIT)

// Recursos utilizados por TODOS los digitos
    .equ DIG_GPIO,      0
    .equ DIG_OFFSET,    ( DIG_GPIO << 2 )
    .equ DIG_MASK,      ( DIG_1_MASK | DIG_2_MASK | DIG_3_MASK | DIG_4_MASK )


// --------------------------------------------------------------------------


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
    .equ SEG_N_GPIO,      2
    .equ SEG_N_OFFSET,    ( SEG_N_GPIO << 2 )
    .equ SEG_N_MASK,      ( SEG_A_MASK | SEG_B_MASK | SEG_C_MASK | SEG_D_MASK | SEG_E_MASK | SEG_F_MASK | SEG_G_MASK )

// Segmento DP (el punto) de los display 7 segmentos
    .equ SEG_DP_PORT,    6
    .equ SEG_DP_PIN,     8
    .equ SEG_DP_BIT,     16
    .equ SEG_DP_MASK,    (1 << SEG_DP_BIT)

    .equ SEG_DP_GPIO,    5
    .equ SEG_DP_OFFSET,  (SEG_DP_GPIO << 2)


// --------------------------------------------------------------------------


@ // Recursos utilizados por el 1er boton del poncho
@     .equ BOTON_1_PORT,    4
@     .equ BOTON_1_PIN,     8
@     .equ BOTON_1_BIT,     12
@     .equ BOTON_1_MASK,    (1 << BOTON_1_BIT)

@ // Recursos utilizados por el 2do boton del poncho
@     .equ BOTON_2_PORT,    4
@     .equ BOTON_2_PIN,     9
@     .equ BOTON_2_BIT,     13
@     .equ BOTON_2_MASK,    (1 << BOTON_2_BIT)

@ // Recursos utilizados por el 3er boton del poncho
@     .equ BOTON_3_PORT,    4
@     .equ BOTON_3_PIN,     10
@     .equ BOTON_3_BIT,     14
@     .equ BOTON_3_MASK,    (1 << BOTON_3_BIT)

@ // Recursos utilizados por el 4to boton del poncho
@     .equ BOTON_4_PORT,    6
@     .equ BOTON_4_PIN,     7
@     .equ BOTON_4_BIT,     15
@     .equ BOTON_4_MASK,    (1 << BOTON_4_BIT)

@ // Recursos utilizados por el boton ACEPTAR del poncho
@     .equ BOTON_A_PORT,    3
@     .equ BOTON_A_PIN,     1
@     .equ BOTON_A_BIT,     8
@     .equ BOTON_A_MASK,    (1 << BOTON_A_BIT)

@ // Recursos utilizados por el boton CANCELAR del poncho
@     .equ BOTON_C_PORT,    3
@     .equ BOTON_C_PIN,     2
@     .equ BOTON_C_BIT,     9
@     .equ BOTON_C_MASK,    (1 << BOTON_C_BIT)

@ // Recursos utilizados por los 4 botones del poncho
@     .equ BOTON_GPIO,      5
@     .equ BOTON_OFFSET,    ( BOTON_GPIO << 2 )
@     .equ BOTON_MASK,      ( BOTON_1_MASK | BOTON_2_MASK | BOTON_3_MASK | BOTON_4_MASK | BOTON_A_MASK | BOTON_C_MASK )
