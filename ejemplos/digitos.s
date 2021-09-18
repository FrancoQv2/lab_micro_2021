    .cpu cortex-m4          // Indica el procesador de destino  
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

/****************************************************************************/
/* Declaraciones de macros para acceso simbolico a los recursos             */
/****************************************************************************/

	// Recursos utilizados por el primer segmento
    .equ SA_PORT,	4
    .equ SA_PIN,	0
    .equ SA_BIT,	0
    .equ SA_MASK,	(1 << SA_BIT)

	// Recursos utilizados por el segundo segmento
    .equ SB_PORT,	4
    .equ SB_PIN,	1
    .equ SB_BIT,	1
    .equ SB_MASK,	(1 << SB_BIT)

	// Recursos utilizados por el tercer segmento
    .equ SC_PORT,	4
    .equ SC_PIN,	2
    .equ SC_BIT,	2
    .equ SC_MASK,	(1 << SC_BIT)

	// Recursos utilizados por el cuatro segmento
    .equ SD_PORT,	4
    .equ SD_PIN,	3
    .equ SD_BIT,	3
    .equ SD_MASK,	(1 << SD_BIT)

	// Recursos utilizados por el quint segmento
    .equ SE_PORT,	4
    .equ SE_PIN,	4
    .equ SE_BIT,	4
    .equ SE_MASK,	(1 << SE_BIT)

	// Recursos utilizados por el sexto segmento
    .equ SF_PORT,	4
    .equ SF_PIN,	5
    .equ SF_BIT,	5
    .equ SF_MASK,	(1 << SF_BIT)

	// Recursos utilizados por el septimo segmento
    .equ SG_PORT,	4
    .equ SG_PIN,	6
    .equ SG_BIT,	6
    .equ SG_MASK,	(1 << SG_BIT)

	// Recursos utilizados por los segmentos en general
    .equ SEG_GPIO,	2
    .equ SEG_MASK,	( SA_MASK | SB_MASK | SC_MASK | SD_MASK | SE_MASK | SF_MASK | SG_MASK )

	// Recursos utilizados por el primer digito
    .equ D1_PORT,	0
    .equ D1_PIN,	0
    .equ D1_BIT,	0
    .equ D1_MASK,	(1 << D1_BIT)

	// Recursos utilizados por el segundo digito
    .equ D2_PORT,	0
    .equ D2_PIN,	1
    .equ D2_BIT,	1
    .equ D2_MASK,	(1 << D2_BIT)

	// Recursos utilizados por el tercer digito
    .equ D3_PORT,	1
    .equ D3_PIN,	15
    .equ D3_BIT,	2
    .equ D3_MASK,	(1 << D3_BIT)

	// Recursos utilizados por el cuatro digito
    .equ D4_PORT,	1
    .equ D4_PIN,	17
    .equ D4_BIT,	3
    .equ D4_MASK,	(1 << D4_BIT)

	// Recursos utilizados por los digitos en general
    .equ DIG_GPIO,	0
    .equ DIG_MASK,	( D1_MASK | D2_MASK | D3_MASK | D4_MASK)

	// Recursos utilizados por la primera tecla de funcion
    .equ B1_PORT,	4
    .equ B1_PIN,	8
    .equ B1_BIT,	12
    .equ B1_MASK,	(1 << B1_BIT)

	// Recursos utilizados por la segunda tecla de funcion
    .equ B2_PORT,	4
    .equ B2_PIN,	9
    .equ B2_BIT,	13
    .equ B2_MASK,	(1 << B2_BIT)

	// Recursos utilizados por la tercera tecla de funcion
    .equ B3_PORT,	4
    .equ B3_PIN,	10
    .equ B3_BIT,	14
    .equ B3_MASK,	(1 << B3_BIT)

	// Recursos utilizados por la cuarta tecla de funcion
    .equ B4_PORT,	6
    .equ B4_PIN,	7
    .equ B4_BIT,	15
    .equ B4_MASK,	(1 << B4_BIT)

	// Recursos utilizados por la tecla aceptar
    .equ BA_PORT,	3
    .equ BA_PIN,	1
    .equ BA_BIT,	8
    .equ BA_MASK,	(1 << BA_BIT)

	// Recursos utilizados por la tecla cancelar
    .equ BC_PORT,	3
    .equ BC_PIN,	2
    .equ BC_BIT,	9
    .equ BC_MASK,	(1 << BC_BIT)

    .equ BOT_GPIO,	5
    .equ BOT_MASK,	( B1_MASK | B2_MASK | B3_MASK | B4_MASK | BA_MASK | BC_MASK)

    .equ ET0,       0
    .equ ET1,       1
    .equ ET3,       3
    .equ ET4,       4
    .equ EF0,       24
    .equ ES0,       32

/****************************************************************************/
/* Función para la inicialización del hardware de la alarma                 */
/****************************************************************************/
    .section .text
    .func configurar
    .align 

configurar:
    // Configuración de los pines de segmentos como gpio sin pull-up

    LDR R1,=SCU_BASE
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(SA_PORT << 7 | SA_PIN << 2)]
    STR R0,[R1,#(SB_PORT << 7 | SB_PIN << 2)]
    STR R0,[R1,#(SC_PORT << 7 | SC_PIN << 2)]
    STR R0,[R1,#(SD_PORT << 7 | SD_PIN << 2)]
    STR R0,[R1,#(SE_PORT << 7 | SE_PIN << 2)]
    STR R0,[R1,#(SF_PORT << 7 | SF_PIN << 2)]
    STR R0,[R1,#(SG_PORT << 7 | SG_PIN << 2)]

    // Configuración de los pines de digitos como gpio sin pull-up
    STR R0,[R1,#(D1_PORT << 7 | D1_PIN << 2)]
    STR R0,[R1,#(D2_PORT << 7 | D2_PIN << 2)]
    STR R0,[R1,#(D3_PORT << 7 | D3_PIN << 2)]
    STR R0,[R1,#(D4_PORT << 7 | D4_PIN << 2)]

    // Configuración de los pines de teclas como gpio con pull-up
    MOV R0,#(SCU_MODE_PULLUP | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    STR R0,[R1,#(B1_PORT << 7 | B1_PIN << 2)]
    STR R0,[R1,#(B2_PORT << 7 | B2_PIN << 2)]
    STR R0,[R1,#(B3_PORT << 7 | B3_PIN << 2)]
    STR R0,[R1,#(B4_PORT << 7 | B4_PIN << 2)]
    STR R0,[R1,#(BA_PORT << 7 | BA_PIN << 2)]
    STR R0,[R1,#(BC_PORT << 7 | BC_PIN << 2)]

    // Apagado de todos los bits gpio de los segmentos
    LDR R1,=GPIO_CLR0
    LDR R0,=SEG_MASK
    STR R0,[R1,#(SEG_GPIO << 2)]

    // Apagado de todos bits gpio de los digitos
    LDR R0,=DIG_MASK
    STR R0,[R1,#(DIG_GPIO << 2)]

    // Configuración de los bits gpio de segmentos como salidas
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#(SEG_GPIO << 2)]
    ORR R0,#SEG_MASK
    STR R0,[R1,#(SEG_GPIO << 2)]

    // Configuración de los bits gpio de digitos como salidas
    LDR R0,[R1,#(SEG_GPIO << 2)]
    ORR R0,#DIG_MASK
    STR R0,[R1,#(DIG_GPIO << 2)]

    // Configuración los bits gpio de botones como entradas
    LDR R0,[R1,#(BOT_GPIO << 2)]
    AND R0,#~BOT_MASK
    STR R0,[R1,#(BOT_GPIO << 2)]	
  
    BX LR

    .pool
    .endfunc
