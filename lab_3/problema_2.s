    .cpu 	cortex-m4       // Indica el procesador de destino  
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"

/* Definición de macros ***********************************************/
// EDU-CIAA LED -------------------------------------------------------------------------
    // Recursos utilizados por el Led 1 (Está en un GPIO distinto)
    .equ LED_1_PORT,    2
    .equ LED_1_PIN,     10
    .equ LED_1_BIT,     14
    .equ LED_1_MASK,    (1 << LED_1_BIT)

    .equ LED_1_GPIO,    0
    .equ LED_1_OFFSET,  (LED_1_GPIO << 2)

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

// PONCHO 7 SEGMENTOS -------------------------------------------------------------------------
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

    // Recursos utilizados por TODOS los segmentos
    .equ SEG_GPIO,      2
    .equ SEG_OFFSET,    ( SEG_GPIO << 2 )
    .equ SEG_MASK,      ( SEG_B_MASK | SEG_C_MASK | SEG_E_MASK | SEG_F_MASK )
    
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

    // Recursos utilizados por los 4 botones del poncho
    .equ BOTON_GPIO,      5
    .equ BOTON_OFFSET,    ( BOTON_GPIO << 2 )
    .equ BOTON_MASK,      ( BOTON_1_MASK | BOTON_2_MASK | BOTON_3_MASK | BOTON_4_MASK )



/* Vector de Interrupciones ***********************************************/
    .section .isr            // Define una seccion especial para el vector
    .word   stack           // 0: Initial SP Stack Pointer value
    .word   reset+1         // 1: Initial PC Program Counter value
    .word   handler+1       // 2: Non mascarable ISR Interrupt Service Routine
    .word   handler+1       // 3: Hard fault System Trap Service Routine
    .word   handler+1       // 4: Memory manager System Trap Service Routine
    .word   handler+1       // 5: Bus fault System Trap Service Routine
    .word   handler+1       // 6: Usage fault System Trap Service Routine
    .word   0               // 7: Reserved entry
    .word   0               // 8: Reserved entry
    .word   0               // 9: Reserved entry
    .word   0               // 10: Reserved entry
    .word   handler+1       // 11: System service call Trap Service Routine
    .word   0               // 12: Reserved entry
    .word   0               // 13: Reserved entry
    .word   handler+1       // 14: Pending service System Trap Service Routine
    .word   handler+1       // 15: System tick service routine
    .word   handler+1       // 16: Interrupt IRQ service routine

/* Definición de variables globales ***********************************************/
    .section .data          // Define la seccion de variables (RAM)
espera:
    .zero   1               // Variable compartida con el tiempo de espera

/* Programa principal *****************************************************/
    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func	main            // Indica al depurador el inicio de una funcion

reset:
// Mueve el Vector de Interrupciones al principio de la 2da RAM
    LDR R1,=VTOR
    LDR R0,=#0x10080000
    STR R0,[R1]

    LDR R1,=SCU_BASE

    // Configura el pin del led 1 como GPIO s/pull-up F0
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(LED_1_PORT << 7 | LED_1_PIN << 2)]
    
    // Configura los segmentos de los DIGITOS del poncho como GPIO s/pull-up F0
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(DIG_1_PORT << 7 | DIG_1_PIN << 2)]     //P0_0
    STR R0,[R1,#(DIG_2_PORT << 7 | DIG_2_PIN << 2)]     //P0_1
    STR R0,[R1,#(DIG_3_PORT << 7 | DIG_3_PIN << 2)]     //P1_15
    STR R0,[R1,#(DIG_4_PORT << 7 | DIG_4_PIN << 2)]     //P1_17
    
    // Configura los segmentos de los 7 segmentos del poncho como GPIO s/pull-up F0
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(SEG_B_PORT << 7 | SEG_B_PIN << 2)]     //P4_1
    STR R0,[R1,#(SEG_C_PORT << 7 | SEG_C_PIN << 2)]     //P4_2
    STR R0,[R1,#(SEG_E_PORT << 7 | SEG_E_PIN << 2)]     //P4_4
    STR R0,[R1,#(SEG_F_PORT << 7 | SEG_F_PIN << 2)]     //P4_5
      
    // Configura los pines de los botones del poncho como GPIO F4
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    STR R0,[R1,#(BOTON_1_PORT << 7 | BOTON_1_PIN << 2)]     //P4_8
    STR R0,[R1,#(BOTON_2_PORT << 7 | BOTON_2_PIN << 2)]     //P4_9
    STR R0,[R1,#(BOTON_3_PORT << 7 | BOTON_3_PIN << 2)]     //P4_10
    STR R0,[R1,#(BOTON_4_PORT << 7 | BOTON_4_PIN << 2)]     //P6_7


    LDR R1,=GPIO_CLR0
    // Se apagan los bits GPIO de los leds 1 al 3
    LDR R0,=LED_1_MASK
    STR R0,[R1,#LED_1_OFFSET]
    // Se apagan los bits GPIO de los Digitos
    LDR R0,=DIG_MASK
    STR R0,[R1,#DIG_OFFSET]
    // Se apagan los bits GPIO de los segmentos B,C,E,F
    LDR R0,=SEG_MASK
    STR R0,[R1,#SEG_OFFSET]


    LDR R1,=GPIO_DIR0
    // Configuro los bits GPIO del led 1 como salida
    LDR R0,=LED_1_MASK
    STR R0,[R1,#LED_1_OFFSET]
    // Configuro los bits GPIO de los Digitos como salidas
    LDR R0,=DIG_MASK
    STR R0,[R1,#DIG_OFFSET]
    // Configuro los bits GPIO de los segmentos B,C,E,F como salidas
    LDR R0,=SEG_MASK
    STR R0,[R1,#SEG_OFFSET]

    // Configuro los bits GPIO de las teclas como entradas
    LDR R0,[R1,#BOTON_GPIO]
    BIC R0,#BOTON_MASK
    STR R0,[R1,#BOTON_OFFSET]

    // Define los punteros para usar el programa
    LDR R4,=GPIO_PIN0
    LDR R5,=GPIO_NOT0

    MOV     R6,#0x00                // Define el estado actual de los digitos como todos apagados
    STR     R6,[R4,#DIG_OFFSET]     // Actualiza las salidas con el estado definido para los digitos

// Verifico por polling si se tocó alguna tecla
refrescar:
    MOV     R3,#0x00                // Define el estado actual de los segmentos como todos apagados
    LDR     R0,[R4,#BOTON_OFFSET]   // Carga el estado actual de las teclas

    TEQ     R0,#BOTON_1_MASK        // Verifica el estado del bit correspondiente al boton 1
    ITT     EQ                      // Si la tecla está apretada
    ORREQ   R6,#DIG_1_MASK          // Enciende el bit del Digito 4
    ORREQ   R3,#SEG_B_MASK          // Enciende el bit de los segmentos B,C,E,F

    // Enciende el segmento C si el boton 2 está apretado
    TEQ     R0,#BOTON_2_MASK
    ITT     EQ
    ORREQ   R6,#DIG_1_MASK
    ORREQ   R3,#SEG_C_MASK

    // Enciende el segmento E si el boton 3 está apretado
    TEQ     R0,#BOTON_3_MASK
    ITT     EQ
    ORREQ   R6,#DIG_1_MASK
    ORREQ   R3,#SEG_E_MASK

    // Enciende el segmento F si el boton 4 está apretado
    TEQ     R0,#BOTON_4_MASK
    ITT     EQ
    ORREQ   R6,#DIG_1_MASK
    ORREQ   R3,#SEG_F_MASK

    STR     R6,[R4,#DIG_OFFSET]     // Actualiza las salidas con el estado definido para los digitos
    STR     R3,[R4,#SEG_OFFSET]     // Actualiza las salidas con el estado definido para los segmentos

    B refrescar

stop:
    B stop
    
    .pool                   // Almacenar las constantes de codigo
    .endfunc


/************************************************************************************/
/* Rutina de servicio generica para excepciones                                     */
/* Esta rutina atiende todas las excepciones no utilizadas en el programa           */
/* Se declara como una medida de seguridad para evitar que el procesador            */
/* se pierda cuando hay una excepcion no prevista por el programador                */
/************************************************************************************/
    .func handler
handler:
    LDR R1,=GPIO_SET0           // Se apunta a la base de registros SET
    MOV R0,#LED_1_MASK          // Se carga la mascara para el LED 1
    STR R0,[R1,#LED_1_OFFSET]   // Se activa el bit GPIO del LED 1
    B handler                   // Lazo infinito para detener la ejecucion
    .pool                   // Se almacenan las constantes de codigo
    .endfunc
