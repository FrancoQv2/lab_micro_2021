    .cpu cortex-m4          // Indica el procesador de destino
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"
    @ .include "configuraciones/poncho.s"

    /****************************************************************************/
    /* Definiciones de macros                                                   */
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

    // Recursos utilizados por el punto del display
    // Segmento DP (el punto) de los display 7 segmentos
    .equ SEG_DP_PORT,      6
    .equ SEG_DP_PIN,       8
    .equ SEG_DP_BIT,       16
    .equ SEG_DP_GPIO,      5
    .equ SEG_DP_MASK,      (1 << SEG_DP_BIT)
    .equ SEG_DP_OFFSET,    (SEG_DP_GPIO << 2)

    /****************************************************************************/
    /* Vector de interrupciones                                                 */
    /****************************************************************************/

    .section .isr           // Define una seccion especial para el vector
    .word   stack           //  0: Initial stack pointer value
    .word   reset+1         //  1: Initial program counter value
    .word   handler+1       //  2: Non mascarable interrupt service routine
    .word   handler+1       //  3: Hard fault system trap service routine
    .word   handler+1       //  4: Memory manager system trap service routine
    .word   handler+1       //  5: Bus fault system trap service routine
    .word   handler+1       //  6: Usage fault system tram service routine
    .word   0               //  7: Reserved entry
    .word   0               //  8: Reserved entry
    .word   0               //  9: Reserved entry
    .word   0               // 10: Reserved entry
    .word   handler+1       // 11: System service call trap service routine
    .word   0               // 12: Reserved entry
    .word   0               // 13: Reserved entry
    .word   handler+1       // 14: Pending service system trap service routine
    .word   handler+1       // 15: System tick service routine
    .word   handler+1       // 16: IRQ 0: DAC service routine
    .word   handler+1       // 17: IRQ 1: M0APP service routine
    .word   handler+1       // 18: IRQ 2: DMA service routine
    .word   0               // 19: Reserved entry
    .word   handler+1       // 20: IRQ 4: FLASHEEPROM service routine
    .word   handler+1       // 21: IRQ 5: ETHERNET service routine
    .word   handler+1       // 22: IRQ 6: SDIO service routine
    .word   handler+1       // 23: IRQ 7: LCD service routine
    .word   handler+1       // 24: IRQ 8: USB0 service routine
    .word   handler+1       // 25: IRQ 9: USB1 service routine
    .word   handler+1       // 26: IRQ 10: SCT service routine
    .word   handler+1       // 27: IRQ 11: RTIMER service routine
    .word   timer_isr+1     // 28: IRQ 12: TIMER0 service routine
    .word   handler+1       // 29: IRQ 13: TIMER1 service routine
    .word   handler+1       // 30: IRQ 14: TIMER2 service routine
    .word   handler+1       // 31: IRQ 15: TIMER3 service routine
    .word   handler+1       // 32: IRQ 16: MCPWM service routine
    .word   handler+1       // 33: IRQ 17: ADC0 service routine
    .word   handler+1       // 34: IRQ 18: I2C0 service routine
    .word   handler+1       // 35: IRQ 19: I2C1 service routine
    .word   handler+1       // 36: IRQ 20: SPI service routine
    .word   handler+1       // 37: IRQ 21: ADC1 service routine
    .word   handler+1       // 38: IRQ 22: SSP0 service routine
    .word   handler+1       // 39: IRQ 23: SSP1 service routine
    .word   handler+1       // 40: IRQ 24: USART0 service routine
    .word   handler+1       // 41: IRQ 25: UART1 service routine
    .word   handler+1       // 42: IRQ 26: USART2 service routine
    .word   handler+1       // 43: IRQ 27: USART3 service routine
    .word   handler+1       // 44: IRQ 28: I2S0 service routine
    .word   handler+1       // 45: IRQ 29: I2S1 service routine
    .word   handler+1       // 46: IRQ 30: SPIFI service routine
    .word   handler+1       // 47: IRQ 31: SGPIO service routine
    .word   handler+1       // 48: IRQ 32: PIN_INT0 service routine
    .word   handler+1       // 49: IRQ 33: PIN_INT1 service routine
    .word   handler+1       // 50: IRQ 34: PIN_INT2 service routine
    .word   handler+1       // 51: IRQ 35: PIN_INT3 service routine
    .word   handler+1       // 52: IRQ 36: PIN_INT4 service routine
    .word   handler+1       // 53: IRQ 37: PIN_INT5 service routine
    .word   handler+1       // 54: IRQ 38: PIN_INT6 service routine
    .word   handler+1       // 55: IRQ 39: PIN_INT7 service routine
    .word   handler+1       // 56: IRQ 40: GINT0 service routine
    .word   handler+1       // 57: IRQ 41: GINT1 service routine

    /****************************************************************************/
    /* Definicion de variables globales                                         */
    /****************************************************************************/

    .section .data          // Define la sección de variables (RAM)
data_segundos:
    .byte 0x08      // base --> unidad
    .byte 0x08      // base+1 --> decena
    
data_minutos:
    .byte 0x00      // base --> unidad
    .byte 0x00      // base+1 --> decena

tabla_conversion:
    .word ( SEG_A_MASK | SEG_B_MASK | SEG_C_MASK | SEG_D_MASK | SEG_E_MASK | SEG_F_MASK )               // 0
	.word ( SEG_B_MASK | SEG_C_MASK )										                            // 1
	.word ( SEG_A_MASK | SEG_B_MASK | SEG_D_MASK | SEG_E_MASK | SEG_G_MASK )	                        // 2
	.word ( SEG_A_MASK | SEG_B_MASK | SEG_C_MASK | SEG_D_MASK | SEG_G_MASK )	                        // 3
	.word ( SEG_B_MASK | SEG_C_MASK | SEG_F_MASK | SEG_G_MASK )				                            // 4
	.word ( SEG_A_MASK | SEG_C_MASK | SEG_D_MASK | SEG_F_MASK | SEG_G_MASK ) 	                        // 5
	.word ( SEG_A_MASK | SEG_C_MASK | SEG_D_MASK | SEG_E_MASK | SEG_F_MASK | SEG_G_MASK )	            // 6
	.word ( SEG_A_MASK | SEG_B_MASK | SEG_C_MASK )				 				                        // 7
	.word ( SEG_A_MASK | SEG_B_MASK | SEG_C_MASK | SEG_D_MASK | SEG_E_MASK | SEG_F_MASK | SEG_G_MASK)   // 8
	.word ( SEG_A_MASK | SEG_B_MASK | SEG_C_MASK | SEG_D_MASK | SEG_F_MASK | SEG_G_MASK )               // 9

    /****************************************************************************/
    /* Programa principal                                                       */
    /****************************************************************************/

    .global reset           // Define el punto de entrada del código
    .section .text          // Define la sección de código (FLASH)
    .func main              // Inidica al depurador el inicio de una funcion
reset:
    CPSID I                 // Deshabilita interrupciones
    
    // Mueve el vector de interrupciones al principio de la segunda RAM
    LDR R1,=VTOR
    LDR R0,=#0x10080000
    STR R0,[R1]

// LDR R1,=SCU_BASE ----------------------------------------------------------------------------------
    LDR R1,=SCU_BASE

    // Configura los DIGITOS del poncho como GPIO s/pull-up F0
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(DIG_1_PORT << 7 | DIG_1_PIN << 2)]     //P0_0
    STR R0,[R1,#(DIG_2_PORT << 7 | DIG_2_PIN << 2)]     //P0_1
    STR R0,[R1,#(DIG_3_PORT << 7 | DIG_3_PIN << 2)]     //P1_15
    STR R0,[R1,#(DIG_4_PORT << 7 | DIG_4_PIN << 2)]     //P1_17

    // Configura los segmentos de los 7 segmentos del poncho como GPIO s/pull-up F0
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(SEG_A_PORT << 7 | SEG_A_PIN << 2)]     //P4_0
    STR R0,[R1,#(SEG_B_PORT << 7 | SEG_B_PIN << 2)]     //P4_1
    STR R0,[R1,#(SEG_C_PORT << 7 | SEG_C_PIN << 2)]     //P4_2
    STR R0,[R1,#(SEG_D_PORT << 7 | SEG_D_PIN << 2)]     //P4_3
    STR R0,[R1,#(SEG_E_PORT << 7 | SEG_E_PIN << 2)]     //P4_4
    STR R0,[R1,#(SEG_F_PORT << 7 | SEG_F_PIN << 2)]     //P4_5
    STR R0,[R1,#(SEG_G_PORT << 7 | SEG_G_PIN << 2)]     //P4_6

    // Configura el pin del punto como salida GPIO
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    STR R0,[R1,#(SEG_DP_PORT << 7 | SEG_DP_PIN << 2)]         //P6_8

// LDR R1,=GPIO_CLR0 ----------------------------------------------------------------------------------
    LDR R1,=GPIO_CLR0

    //Apago todos los bits GPIO de los digitos
    LDR R0,=DIG_MASK
    STR R0,[R1,#DIG_OFFSET]

    //Apago todos los bits GPIO de los segmentos
    LDR R0,=SEG_N_MASK
    STR R0,[R1,#SEG_N_OFFSET]

    LDR R0,=SEG_DP_MASK
    STR R0,[R1,#SEG_DP_OFFSET]

// LDR R1,=GPIO_DIR0 ----------------------------------------------------------------------------------
    LDR R1,=GPIO_DIR0

    //Se configuran los bits gpio de los digitos como salidas
    LDR R0,[R1,#DIG_OFFSET]
    ORR R0,#DIG_MASK
    STR R0,[R1,#DIG_OFFSET]

    @ //Se configuran los bits gpio de los segmentos como como salidas
    LDR R0,=SEG_N_MASK
    STR R0,[R1,#SEG_N_OFFSET]

    // Configura el bit GPIO del punto como salida
    LDR R0,[R1,#SEG_DP_OFFSET]
    ORR R0,#SEG_DP_MASK
    STR R0,[R1,#SEG_DP_OFFSET]

// LDR R1,=GPIO_SET0 ----------------------------------------------------------------------------------
    LDR R1,=GPIO_SET0

    //Se configuran los bits gpio de los digitos como salidas
    LDR R0,[R1,#DIG_OFFSET]
    ORR R0,#DIG_MASK
    STR R0,[R1,#DIG_OFFSET]

// ----------------------------------------------------------------------------------
    // Cuenta con clock interno
    LDR R1,=TIMER0_BASE
    MOV R0,#0x00
    STR R0,[R1,#CTCR]

    // Prescaler de 9.500.000 para una frecuencia de 10 Hz
    LDR R0,=9500000
    STR R0,[R1,#PR]

    // El valor del semiperiodo para 1 Hz
    LDR R0,=5
    STR R0,[R1,#MR3]

    // El registro de match 3 provoca reset del contador
    MOV R0,#(MR3R | MR3I)
    STR R0,[R1,#MCR]

    // Limpieza del contador
    MOV R0,#CRST
    STR R0,[R1,#TCR]

    // Inicio del contador
    MOV R0,#CEN
    STR R0,[R1,#TCR]

    // Limpieza del pedido pendiente en el NVIC
    LDR R1,=NVIC_ICPR0
    MOV R0,(1 << 12)
    STR R0,[R1]

    // Habilitacion del pedido de interrupcion en el NVIC
    LDR R1,=NVIC_ISER0
    MOV R0,(1 << 12)
    STR R0,[R1]

    CPSIE I     // Rehabilita interrupciones

    main:
    B main

    .pool       // Almacenar las constantes de código
    .endfunc

    /****************************************************************************/
    /* Rutina de servicio para la interrupcion del timer                        */
    /****************************************************************************/
    .func timer_isr
timer_isr:
    // Limpio el flag de interrupcion
    LDR R3,=TIMER0_BASE
    LDR R0,[R3,#IR]
    STR R0,[R3,#IR]

    // Cambio el estado del pin GPIO del led
    LDR R3,=GPIO_NOT0
    MOV R0,#SEG_N_MASK
    STR R0,[R3,#SEG_N_OFFSET]

    // Cambio el estado del pin GPIO del led
    LDR R3,=GPIO_NOT0
    MOV R0,#SEG_DP_MASK
    STR R0,[R3,#SEG_DP_OFFSET]

    // Retorno
    BX  LR

    .pool                   // Almacenar las constantes de código
    .endfunc

    /****************************************************************************/
    /* Rutina de servicio generica para excepciones                             */
    /* Esta rutina atiende todas las excepciones no utilizadas en el programa.  */
    /* Se declara como una medida de seguridad para evitar que el procesador    */
    /* se pierda cuando hay una excepcion no prevista por el programador        */
    /****************************************************************************/
    .func handler
handler:
    LDR R0,=set_led_1       // Apuntar al incio de una subrutina lejana
    BLX R0                  // Llamar a la rutina para encender el led rojo
    B handler               // Lazo infinito para detener la ejecucion
    .pool                   // Almacenar las constantes de codigo
    .endfunc
