    .cpu cortex-m4          // Indica el procesador de destino
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"
    .include "configuraciones/edu_ciaa.s"
    .include "configuraciones/poncho.s"

/****************************************************************************/
/* Definiciones de macros                                                   */
/****************************************************************************/
    
    // Todo está definido en edu_ciaa.s y poncho.s

/****************************************************************************/
/* Vector de interrupciones                                                 */
/****************************************************************************/
    .section .isr
    .word   stack           //  0: Initial stack pointer value
    .word   reset+1         //  1: Initial program counter value: Program entry point
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
    .word   systick_isr+1   // 15: System tick service routine
    .word   handler+1       // 16: IRQ 0: DAC service routine

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

data_hora:
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
    // Mueve el vector de interrupciones al principio de la segunda RAM
    LDR R1,=VTOR
    LDR R0,=#0x10080000
    STR R0,[R1]

    // Llama a una subrutina para configurar el systick
    BL systick_init

    LDR R1,=SCU_BASE

    // Configura los DIGITOS del poncho como GPIO s/pull-up F0
    @ MOV R0,#(SCU_MODE_INBUFF_EN | SCU_MODE_INACT | SCU_MODE_FUNC0)
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(DIG_1_PORT << 7 | DIG_1_PIN << 2)]     //P0_0
    STR R0,[R1,#(DIG_2_PORT << 7 | DIG_2_PIN << 2)]     //P0_1
    STR R0,[R1,#(DIG_3_PORT << 7 | DIG_3_PIN << 2)]     //P1_15
    STR R0,[R1,#(DIG_4_PORT << 7 | DIG_4_PIN << 2)]     //P1_17

    
    // Configura los segmentos de los 7 segmentos del poncho como GPIO s/pull-up F0
    @ MOV R0,#(SCU_MODE_INBUFF_EN | SCU_MODE_INACT | SCU_MODE_FUNC0)
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(SEG_A_PORT << 7 | SEG_A_PIN << 2)]     //P4_0
    STR R0,[R1,#(SEG_B_PORT << 7 | SEG_B_PIN << 2)]     //P4_1
    STR R0,[R1,#(SEG_C_PORT << 7 | SEG_C_PIN << 2)]     //P4_2
    STR R0,[R1,#(SEG_D_PORT << 7 | SEG_D_PIN << 2)]     //P4_3
    STR R0,[R1,#(SEG_E_PORT << 7 | SEG_E_PIN << 2)]     //P4_4
    STR R0,[R1,#(SEG_F_PORT << 7 | SEG_F_PIN << 2)]     //P4_5
    STR R0,[R1,#(SEG_G_PORT << 7 | SEG_G_PIN << 2)]     //P4_6
    // Configura el punto de los 7 segmentos del poncho como GPIO s/pull-up F4
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    STR R0,[R1,#(SEG_DP_PORT << 7 | SEG_DP_PIN << 2)]   //P6_8


    LDR R1,=GPIO_CLR0

    //Apago todos los bits gpio de los segmentos
    LDR R0,=SEG_N_MASK
    STR R0,[R1,#SEG_N_OFFSET]
    LDR R0,=SEG_DP_MASK
    STR R0,[R1,#SEG_DP_OFFSET]

    //Apago todos los bits gpio de los digitos
    LDR R0,=DIG_MASK
    STR R0,[R1,#DIG_OFFSET]


    LDR R1,=GPIO_DIR0

    //Se configuran los bits gpio de los segmentos como como salidas
    LDR R0,[R1,#SEG_N_OFFSET]
    ORR R0,#SEG_N_MASK
    STR R0,[R1,#SEG_N_OFFSET]

    //Se configura el bit gpio del segmento DP como como salida
    LDR R0,[R1,#SEG_DP_OFFSET]
    ORR R0,#SEG_DP_MASK
    STR R0,[R1,#SEG_DP_OFFSET]

    //Se configuran los bits gpio de los digitos como salidas
    LDR R0,[R1,#DIG_OFFSET]
    ORR R0,#DIG_MASK
    STR R0,[R1,#DIG_OFFSET]

refrescar:
    B refrescar

    .pool
    .endfunc


/****************************************************************************/
/* Rutina de inicializacion del systick                                     */
/****************************************************************************/
    .func systick_init
systick_init:
    CPSID I                     // Se deshabilitan globalmente las interrupciones

    // Se configura prioridad de la interrupcion
    LDR R1,=SHPR3               // Se apunta al registro de prioridades
    LDR R0,[R1]                 // Se cargan las prioridades actuales
    MOV R2,#2                   // Se fija la prioridad en 2
    BFI R0,R2,#29,#3            // Se inserta el valor en el campo
    STR R0,[R1]                 // Se actualizan las prioridades

    // Se habilita el SysTick con el reloj del nucleo
    LDR R1,=SYST_CSR
    MOV R0,#0x00
    STR R0,[R1]                 // Se quita el bit ENABLE

    // Se configura el desborde para un periodo de 1 ms
    LDR R1,=SYST_RVR
    LDR R0,=#(48007 - 1)
    STR R0,[R1]                 // Se especifica el valor de RELOAD

    // Se inicializa el valor actual del contador
    LDR R1,=SYST_CVR
    MOV R0,#0
    // Escribir cualquier valor limpia el contador
    STR R0,[R1]                 // Se limpia COUNTER y flag COUNT

    // Se habilita el SysTick con el reloj del nucleo
    LDR R1,=SYST_CSR
    MOV R0,#0x07
    STR R0,[R1]                 // Se fijan ENABLE, TICKINT y CLOCK_SRC

    CPSIE I                     // Se habilitan globalmente las interrupciones
    BX  LR                      // Se retorna al programa principal
    .pool                       // Se almacenan las constantes de código
    .endfunc


/****************************************************************************/
/* Rutina de interrupcion del systick                                       */
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
    PUSH {R0,R1,LR}
    BL   actualizar_hora        // Si llegó a 0 el contador salto a actualizar_hora
    POP  {R0,R1,LR}

    MOV  R1,0x6E8               // Reinicio espera al valor original 1768
systick_exit:
    STR  R1,[R0]                // Actualizo espera
    BX   LR

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

    .pool
    .endfunc


/****************************************************************************/
/* Rutina para refrescar los displays                                       */
/****************************************************************************/
/*
    Recibe R6 como parámetro
 */
    .func refrescar_displays
refrescar_displays:
    LDR R4,=GPIO_PIN0               // Apunto a PIN base
    LDR R1,=tabla_conversion        // Apunto a la tabla para convertir a 7 seg

    CMP    R6,#0                       // Si d es 0 salto a encender_punto
    BEQ    encender_punto
    
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

fin_refrescar_displays:
    BX LR
encender_punto:
    B fin_refrescar_displays
    .endfunc


/****************************************************************************/
/* Rutina para actualizar la hora                                           */
/****************************************************************************/
    .func actualizar_hora
actualizar_hora:
    LDR R0,=data_segundos
    LDRB R1,[R0]

    ADD R1,#1
    CMP R1,0xA
    BNE fin_actualizar_hora
    SUB R1,0xA
    STRB R1,[R0]

    LDRB R1,[R0,#1]!

    ADD R1,#1
    CMP R1,0x6
    BNE fin_actualizar_hora
    SUB R1,0x6
    STRB R1,[R0]

    LDR R0,=data_minutos
    LDRB R1,[R0]

    ADD R1,#1
    CMP R1,0xA
    BNE fin_actualizar_hora
    SUB R1,0xA
    STRB R1,[R0]

    LDRB R1,[R0,#1]!

    ADD R1,#1
    CMP R1,0x6
    BNE fin_actualizar_hora
    SUB R1,0x6
    STRB R1,[R0]

fin_actualizar_hora:
    @ PUSH {LR}
    @ BL   parpadear_punto
    @ POP  {LR}
    STRB R1,[R0]
    BX LR
    .pool
    .endfunc


/****************************************************************************/
/* Rutina para actualizar la data_hora                                           */
/****************************************************************************/
    .func parpadear_punto
parpadear_punto:
    PUSH   {R4-R5}
    LDR    R4,=GPIO_CLR0               // Apunto a PIN base
    MOV    R5,#SEG_DP_MASK             // Con esto se prenden todos los puntos :D
    STR    R5,[R4,#SEG_DP_OFFSET]

    LDR    R4,=GPIO_PIN0               // Apunto a PIN base
    STR    R5,[R4,#SEG_DP_OFFSET]

    MOV    R4,#0x100000             // Utilizo una demora de 10 para refrescar los digitos
    demora:
        SUBS  R4,#1
        BNE   demora

    LDR    R4,=GPIO_CLR0               // Apunto a PIN base
    MOV    R5,#SEG_DP_MASK             // Con esto se prenden todos los puntos :D
    STR    R5,[R4,#SEG_DP_OFFSET]

    POP    {R4-R5}
    BX LR
    .pool
    .endfunc


/****************************************************************************/
/* Handler de excepciones                                                   */
/****************************************************************************/
    .func handler
handler:
    LDR R0,=set_led_1       // Apuntar al inicio de una subrutina lejana (rutinas.s)
    BLX R0                  // Llamar a la rutina para encender el led rojo
    B handler               // Lazo infinito para detener la ejecucion
    .pool                   // Almacenar las constantes de codigo
    .endfunc
