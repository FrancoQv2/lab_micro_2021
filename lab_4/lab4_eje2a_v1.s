    .cpu cortex-m4          // Indica el procesador de destino
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"
    @ .include "configuraciones/edu_ciaa.s"
    .include "configuraciones/poncho.s"

    /****************************************************************************/
    /* Definiciones de macros                                                   */
    /****************************************************************************/

    // Recursos utilizados por el punto del display
    .equ LED_PORT,      6
    .equ LED_PIN,       8
    .equ LED_BIT,       16
    .equ LED_GPIO,      5
    .equ LED_MASK,      (1 << LED_BIT)
    .equ LED_OFFSET,    (LED_GPIO << 2)

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
        .word   handler+1   // 14: Pending service system trap service routine
        .word   handler+1       // 15: System tick service routine
        .word   handler+1       // 16: IRQ 0:  DAC service routine
        .word   handler+1       // 17: IRQ 1:  M0APP service routine
        .word   handler+1       // 18: IRQ 2:  DMA service routine
        .word   0               // 19: Reserved entry
        .word   handler+1       // 20: IRQ 4:  FLASHEEPROM service routine
        .word   handler+1       // 21: IRQ 5:  ETHERNET service routine
        .word   handler+1       // 22: IRQ 6:  SDIO service routine
        .word   handler+1       // 23: IRQ 7:  LCD service routine
        .word   handler+1       // 24: IRQ 8:  USB0 service routine
        .word   handler+1       // 25: IRQ 9:  USB1 service routine
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
espera: 
    .word 0x6E8         // Para esperar 1768 veces (??) y no 1000 veces

espera_refresco_display:
    .word 0x5

d:
    .byte 0x00

data_segundos:
    .byte 0x00      // base --> unidad
    .byte 0x00      // base+1 --> decena
    
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
    @ CPSID I                 // Deshabilita interrupciones

    // Mueve el vector de interrupciones al principio de la segunda RAM
    LDR R1,=VTOR
    LDR R0,=#0x10080000
    STR R0,[R1]

    // Llama a una subrutina existente en flash para configurar los leds
    @ LDR R1,=leds_init
    @ BLX R1

    // Llama a una subrutina para configurar el systick
    @ BL systick_init

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

    @ // Configura el punto de los 7 segmentos del poncho como GPIO s/pull-up F4
    @ MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    @ STR R0,[R1,#(SEG_DP_PORT << 7 | SEG_DP_PIN << 2)]   //P6_8

    // Configura el pin del punto como salida GPIO
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    STR R0,[R1,#(LED_PORT << 7 | LED_PIN << 2)]

// LDR R1,=GPIO_CLR0 ----------------------------------------------------------------------------------
    @ LDR R1,=GPIO_CLR0

    @ //Apago todos los bits GPIO de los digitos
    @ LDR R0,=DIG_MASK
    @ STR R0,[R1,#DIG_OFFSET]

    @ //Apago todos los bits GPIO de los segmentos
    @ LDR R0,=SEG_N_MASK
    @ STR R0,[R1,#SEG_N_OFFSET]

    @ LDR R0,=LED_MASK
    @ STR R0,[R1,#LED_OFFSET]

// LDR R1,=GPIO_DIR0 ----------------------------------------------------------------------------------
    LDR R1,=GPIO_DIR0

    //Se configuran los bits gpio de los digitos como salidas
    LDR R0,[R1,#DIG_OFFSET]
    ORR R0,#DIG_MASK
    STR R0,[R1,#DIG_OFFSET]

    //Se configuran los bits gpio de los segmentos como como salidas
    LDR R0,[R1,#SEG_N_OFFSET]
    ORR R0,#SEG_N_MASK
    STR R0,[R1,#SEG_N_OFFSET]

    // Configura el bit GPIO del punto como salida
    LDR R0,[R1,#LED_OFFSET]
    ORR R0,#LED_MASK
    STR R0,[R1,#LED_OFFSET]

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

    // El registro de Match 3 provoca reset del contador
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
    MOV R0,#LED_MASK
    STR R0,[R3,#LED_OFFSET]

    @ PUSH {R0,R1,LR}
    @ BL   actualizar_hora        // Si llegó a 0 el contador salto a actualizar_hora
    @ POP  {R0,R1,LR}

    BX  LR                  // Retorno

    .pool                   // Almacenar las constantes de código
    .endfunc

    /****************************************************************************/
    /* Rutina para actualizar la hora                                           */
    /****************************************************************************/
    .func actualizar_hora
actualizar_hora:
    LDR  R0,=data_segundos          // Cargo los segundos (unidad)
    LDRB R1,[R0]
    ADD  R1,#1
    CMP  R1,0xA
    BNE  actualizar_hora_exit
    SUB  R1,0xA
    STRB R1,[R0]

    LDRB R1,[R0,#1]!                // Cargo los segundos (decena)
    ADD  R1,#1
    CMP  R1,0x6
    BNE  actualizar_hora_exit
    SUB  R1,0x6
    STRB R1,[R0]

    LDR  R0,=data_minutos           // Cargo los minutos (unidad)
    LDRB R1,[R0]
    ADD  R1,#1
    CMP  R1,0xA
    BNE  actualizar_hora_exit
    SUB  R1,0xA
    STRB R1,[R0]

    LDRB R1,[R0,#1]!                // Cargo los minutos (decena)
    ADD  R1,#1
    CMP  R1,0x6
    BNE  actualizar_hora_exit
    SUB  R1,0x6
    STRB R1,[R0]

actualizar_hora_exit:
    STRB R1,[R0]
    BX LR
    .pool
    .endfunc

    /****************************************************************************/
    /* Rutina de inicialización del SysTick                                     */
    /****************************************************************************/
    .func systick_init
systick_init: 
    // Configurar prioridad de la interrupcion
    LDR R1,=SHPR3           // Apunta al registro de prioridades
    LDR R0,[R1]             // Carga las prioridades actuales
    MOV R2,#2               // Fija la prioridad en 2
    BFI R0,R2,#29,#3        // Inserta el valor en el campo 
    STR R0,[R1]             // Actualiza las prioridades

    // Habilitar el SysTick con el reloj del nucleo
    LDR R1,=SYST_CSR    
    MOV R0,#0x00
    STR R0,[R1]             // Quita ENABLE

    // Se configura el desborde para un periodo de 1 ms
    LDR R1,=SYST_RVR
    LDR R0,=#(48007 - 1)
    STR R0,[R1]             // Especifica valor RELOAD

    // Inicializar el valor actual del contador
    // Escribir cualquier valor limpia el contador
    LDR R1,=SYST_CVR 
    MOV R0,#0
    STR R0,[R1]             // Limpia COUNTER y flag COUNT
    
    // Habilita el SysTick con el reloj del nucleo
    LDR R1,=SYST_CSR    
    MOV R0,#0x07
    STR R0,[R1]             // Fija ENABLE, TICKINT y CLOCK_SRC

    BX  LR                  // Retorna al programa principal
    .pool                   // Almacena las constantes de código
    .endfunc

    /****************************************************************************/
    /* Rutina de servicio para la interrupcion del SysTick                      */
    /****************************************************************************/
    .func systick_isr
systick_isr:
    LDR  R0,=espera_refresco_display            // Apunto a la variable de espera que maneja el display
    LDR  R1,[R0]                                // Cargo el valor en R1
    SUB  R1,#1                                  // espera <- espera-1
    CMP  R1,0x00                                // Si llegó a 0 pasaron 5 iteraciones
    BEQ  systick_llamada_refrescar_displays     // Salto si 0
    STRB R1,[R0]                                // Actualizo espera si no saltó y luego entra a fin_llamada

fin_llamada:
    LDR  R0,=espera             // Apunto a la variable espera que maneja el reloj
    LDR  R1,[R0]                // Cargo el valor
    SUBS R1,#1                  // espera <- espera-1
    BHI  systick_exit           // Salta si no llegó a 0 (no hubo 1768 iteraciones)

    @ PUSH {LR}
    @ BL   parpadear_punto        // Si llegó a 0 el contador salto a actualizar_hora
    @ POP  {LR}
    @ PUSH {R0,R1,LR}
    @ BL   actualizar_hora        // Si llegó a 0 el contador salto a actualizar_hora
    @ POP  {R0,R1,LR}

    MOV  R1,0x6E8               // Reinicio espera al valor original 1768
systick_exit:
    STRB R1,[R0]            // Actualiza la variable espera
    BX   LR                 // Retorna al programa principal
systick_llamada_refrescar_displays:
    LDR   R5,=d                 // Apunta a d(?)
    LDRB  R6,[R5]               // Cargo el valor en R6

    PUSH  {R0-R6,LR}
    BL    refrescar_displays
    POP   {R0-R6,LR}

    MOV   R1,0x5                // Cargo el valor original de espera_refresco_display
    STR   R1,[R0]               // Lo actualizo
    ADD   R6,#1                 // Aumento d en 1
    CMP   R6,#5                 // Veo si d llegó a 5
    IT    EQ
    MOVEQ R6,0x00               // Si llegó a 5 lo reinicio a 0
    STRB  R6,[R5]               // Lo actualizo
    B     fin_llamada

    .pool                   // Almacena las constantes de código
    .endfunc 

    /****************************************************************************/
    /* Rutina para refrescar los displays                                       */
    // Recibe R6 como parámetro
    /****************************************************************************/

    .func refrescar_displays
refrescar_displays:
    LDR R4,=GPIO_PIN0               // Apunto a PIN base
    LDR R1,=tabla_conversion        // Apunto a la tabla para convertir a 7 seg
    
    CMP    R6,#1                    // Si d=1 actualizo el digito 1 con unidad de segundo
    ITTT   EQ
    LDREQ  R0,=data_segundos
    LDRBEQ R2,[R0]
    MOVEQ  R3,#DIG_1_MASK

    CMP    R6,#2                    // Si d=2 actualizo el digito 2 con decena de segundo
    ITTT   EQ
    LDREQ  R0,=data_segundos+1
    LDRBEQ R2,[R0]
    MOVEQ  R3,#DIG_2_MASK

    CMP    R6,#3                    // Si d=3 actualizo el digito 3 con unidad de minuto
    ITTT   EQ
    LDREQ  R0,=data_minutos
    LDRBEQ R2,[R0]
    MOVEQ  R3,#DIG_3_MASK

    CMP    R6,#4                    // Si d=4 actualizo el digito 4 con decena de minuto
    ITTT   EQ
    LDREQ  R0,=data_minutos+1
    LDRBEQ R2,[R0]
    MOVEQ  R3,#DIG_4_MASK

    LDR  R2,[R1,R2,LSL #2]          // Conversion a 7seg el numero

    STR  R2,[R4,#SEG_N_OFFSET]
    STR  R3,[R4,#DIG_OFFSET]

    BX LR
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
