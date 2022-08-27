    .cpu cortex-m4          // Indica el procesador de destino
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"
    .include "configuraciones/ciaa.s"

/****************************************************************************/
/* Definiciones de macros                                                   */
/****************************************************************************/
  
// Recursos utilizados por la primera tecla
    .equ TEC_1_PORT,    4
    .equ TEC_1_PIN,     8
    .equ TEC_1_BIT,     12
    .equ TEC_1_MASK,    (1 << TEC_1_BIT)

// Recursos utilizados por la segunda tecla
    .equ TEC_2_PORT,    4
    .equ TEC_2_PIN,     9
    .equ TEC_2_BIT,     13
    .equ TEC_2_MASK,    (1 << TEC_2_BIT)

// Recursos utilizados por la tercera tecla
    .equ TEC_3_PORT,    4
    .equ TEC_3_PIN,     10
    .equ TEC_3_BIT,     14
    .equ TEC_3_MASK,    (1 << TEC_3_BIT)

// Recursos utilizados por la cuarta tecla
    .equ TEC_4_PORT,    6
    .equ TEC_4_PIN,     7
    .equ TEC_4_BIT,     15
    .equ TEC_4_MASK,    (1 << TEC_4_BIT)

// Recursos utilizados por la tecla aceptar
    .equ TEC_A_PORT,    3
    .equ TEC_A_PIN,     1
    .equ TEC_A_BIT,     8
    .equ TEC_A_MASK,    (1 << TEC_A_BIT)

// Recursos utilizados por la tecla cancelar
    .equ TEC_C_PORT,    3
    .equ TEC_C_PIN,     2
    .equ TEC_C_BIT,     9
    .equ TEC_C_MASK,    (1 << TEC_C_BIT)

// Recursos utilizados por el teclado
    .equ TEC_N_GPIO,      5
    .equ TEC_N_OFFSET,    ( TEC_N_GPIO << 2)
    .equ TEC_N_MASK,      ( TEC_1_MASK | TEC_2_MASK | TEC_3_MASK | TEC_4_MASK | TEC_A_MASK | TEC_C_MASK) 

    .equ TEC1, (TEC_N_GPIO << 5 | TEC_1_BIT)
    .equ TEC2, (TEC_N_GPIO << 5 | TEC_2_BIT)
    .equ TEC3, (TEC_N_GPIO << 5 | TEC_3_BIT)
    .equ TEC4, (TEC_N_GPIO << 5 | TEC_4_BIT)
    .equ TECA, (TEC_N_GPIO << 5 | TEC_A_BIT)
    .equ TECC, (TEC_N_GPIO << 5 | TEC_C_BIT)
    

// Recursos utilizados por el digito 1
    .equ DIG_1_PORT,    0
    .equ DIG_1_PIN,     0
    .equ DIG_1_BIT,     0
    .equ DIG_1_MASK,    (1 << DIG_1_BIT)

// Recursos utilizados por el digito 2
    .equ DIG_2_PORT,    0
    .equ DIG_2_PIN,     1
    .equ DIG_2_BIT,     1
    .equ DIG_2_MASK,    (1 << DIG_2_BIT)

// Recursos utilizados por el digito 3
    .equ DIG_3_PORT,    1
    .equ DIG_3_PIN,     15
    .equ DIG_3_BIT,     2
    .equ DIG_3_MASK,    (1 << DIG_3_BIT)

// Recursos utilizados por el digito 4
    .equ DIG_4_PORT,    1
    .equ DIG_4_PIN,     16
    .equ DIG_4_BIT,     3
    .equ DIG_4_MASK,    (1 << DIG_4_BIT)

// Recursos utilizados por los display
    .equ DIG_N_GPIO,      0
    .equ DIG_N_OFFSET,    ( DIG_N_GPIO << 2)
    .equ DIG_N_MASK,      ( DIG_1_MASK | DIG_2_MASK | DIG_3_MASK | DIG_4_MASK)

// Recursos utilizados por el segmento A
    .equ SEG_A_PORT,    4
    .equ SEG_A_PIN,     0
    .equ SEG_A_BIT,     0
    .equ SEG_A_MASK,    (1 << SEG_A_BIT)

// Recursos utilizados por el segmento B
    .equ SEG_B_PORT,    4
    .equ SEG_B_PIN,     1
    .equ SEG_B_BIT,     1
    .equ SEG_B_MASK,    (1 << SEG_B_BIT)

// Recursos utilizados por el segmento C
    .equ SEG_C_PORT,    4
    .equ SEG_C_PIN,     2
    .equ SEG_C_BIT,     2
    .equ SEG_C_MASK,    (1 << SEG_C_BIT)

// Recursos utilizados por el segmento D
    .equ SEG_D_PORT,    4
    .equ SEG_D_PIN,     3
    .equ SEG_D_BIT,     3
    .equ SEG_D_MASK,    (1 << SEG_D_BIT)

// Recursos utilizados por el segmento E
    .equ SEG_E_PORT,    4
    .equ SEG_E_PIN,     4
    .equ SEG_E_BIT,     4
    .equ SEG_E_MASK,    (1 << SEG_E_BIT)

// Recursos utilizados por el segmento F
    .equ SEG_F_PORT,    4
    .equ SEG_F_PIN,     5
    .equ SEG_F_BIT,     5
    .equ SEG_F_MASK,    (1 << SEG_F_BIT)

// Recursos utilizados por el segmento G
    .equ SEG_G_PORT,    4
    .equ SEG_G_PIN,     6
    .equ SEG_G_BIT,     6
    .equ SEG_G_MASK,    (1 << SEG_G_BIT)

// Recursos utilizados por el segmento DP
    .equ SEG_DP_PORT,    6
    .equ SEG_DP_PIN,     8
    .equ SEG_DP_BIT,     16
    .equ SEG_DP_MASK,    (1 << SEG_DP_BIT)

// Recursos utilizados por los segmentos
    .equ SEG_N_GPIO,      2
    .equ SEG_N_OFFSET,    ( SEG_N_GPIO << 2)
    .equ SEG_N_MASK,      ( SEG_A_MASK | SEG_B_MASK | SEG_C_MASK | SEG_D_MASK | SEG_E_MASK | SEG_F_MASK | SEG_G_MASK)

// Recursos utilizados por el segmento DP
    .equ SEG_N1_GPIO,      5
    .equ SEG_N1_OFFSET,    ( SEG_N1_GPIO << 2)
    .equ SEG_N1_MASK,      ( SEG_DP_MASK )

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
    .word   handler+1       // 28: IRQ 12: TIMER0 service routine
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
    .word   gpio_isr+1      // 48: IRQ 32: PIN_INT0 service routine
    .word   gpio_isr+1      // 49: IRQ 33: PIN_INT1 service routine
    .word   gpio_isr+1      // 50: IRQ 34: PIN_INT2 service routine
    .word   gpio_isr+1      // 51: IRQ 35: PIN_INT3 service routine
    .word   handler+1       // 52: IRQ 36: PIN_INT4 service routine
    .word   handler+1       // 53: IRQ 37: PIN_INT5 service routine
    .word   handler+1       // 54: IRQ 38: PIN_INT6 service routine
    .word   handler+1       // 55: IRQ 39: PIN_INT7 service routine
    .word   handler+1       // 56: IRQ 40: GINT0 service routine
    .word   handler+1       // 56: IRQ 40: GINT1 service routine 

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data          // Define la sección de variables (RAM)
//Para esperar 1000 veces
espera: 
    .word 0x6E8
//Para esperar 5 veces antes de refrescar cada display
espera_refresco_display:
    .word 0x5
//Controla que display debe prenderse en cada refresco
d:      
    .byte 0x00
activa:
    .byte 0x00
//segundos Base:    unidad
//segundos Base+1:  decena    
segundos:
    .byte 0x00
    .byte 0x00
//minutos Base:     unidad
//minutos Base+1:   decena
minutos:
    .byte 0x00
    .byte 0x00
//hora Base:        unidad
//hora Base+1:      decena
hora:
    .byte 0x00
    .byte 0x00

tabla_refresco:
    .word SEG_A_MASK + SEG_B_MASK + SEG_C_MASK + SEG_D_MASK + SEG_E_MASK + SEG_F_MASK       //0
    .word SEG_B_MASK + SEG_C_MASK                                                           //1
    .word SEG_A_MASK + SEG_B_MASK + SEG_G_MASK + SEG_E_MASK + SEG_D_MASK                    //2
    .word SEG_A_MASK + SEG_B_MASK + SEG_C_MASK + SEG_D_MASK + SEG_G_MASK                    //3
    .word SEG_B_MASK + SEG_C_MASK + SEG_F_MASK + SEG_G_MASK                                 //4
    .word SEG_A_MASK + SEG_F_MASK + SEG_G_MASK + SEG_C_MASK + SEG_D_MASK                    //5
    .word SEG_A_MASK + SEG_C_MASK + SEG_D_MASK + SEG_E_MASK + SEG_F_MASK + SEG_G_MASK       //6
    .word SEG_A_MASK + SEG_B_MASK + SEG_C_MASK                                              //7
    .word SEG_A_MASK + SEG_B_MASK + SEG_C_MASK + SEG_D_MASK + SEG_E_MASK + SEG_F_MASK + SEG_G_MASK //8
    .word SEG_A_MASK + SEG_B_MASK + SEG_C_MASK + SEG_D_MASK + SEG_F_MASK + SEG_G_MASK       //9


@ tabla_refresco:
@            //0

@         .word SEG_A_MASK + SEG_B_MASK + SEG_C_MASK + SEG_D_MASK + SEG_F_MASK + SEG_G_MASK       //9
@     .word SEG_A_MASK + SEG_B_MASK + SEG_C_MASK + SEG_D_MASK + SEG_E_MASK + SEG_F_MASK + SEG_G_MASK //8
@     .word SEG_A_MASK + SEG_B_MASK + SEG_C_MASK
@     .word SEG_A_MASK + SEG_C_MASK + SEG_D_MASK + SEG_E_MASK + SEG_F_MASK + SEG_G_MASK
@     .word SEG_A_MASK + SEG_F_MASK + SEG_G_MASK + SEG_C_MASK + SEG_D_MASK
@     .word SEG_B_MASK + SEG_C_MASK + SEG_F_MASK + SEG_G_MASK
@     .word SEG_A_MASK + SEG_B_MASK + SEG_C_MASK + SEG_D_MASK + SEG_G_MASK
@     .word SEG_A_MASK + SEG_B_MASK + SEG_G_MASK + SEG_E_MASK + SEG_D_MASK                    //2
@     .word SEG_B_MASK + SEG_C_MASK
@     .word SEG_A_MASK + SEG_B_MASK + SEG_C_MASK + SEG_D_MASK + SEG_E_MASK + SEG_F_MASK
/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .global reset           // Define el punto de entrada del código
    .section .text          // Define la sección de código (FLASH)
    .func main              // Inidica al depurador el inicio de una funcion
reset:
    CPSID I

    // Mueve el vector de interrupciones al principio de la segunda RAM
    LDR R1,=VTOR
    LDR R0,=#0x10080000
    STR R0,[R1]

    // Llama a una subrutina para configurar el systick
    BL systick_init

    LDR R1,=SCU_BASE

    // Configura los pines de las teclas como gpio con pull-up
    MOV R0,#( SCU_MODE_INBUFF_EN | SCU_MODE_FUNC4)
    STR R0,[R1,#((TEC_1_PORT << 5 | TEC_1_PIN) << 2)]
    STR R0,[R1,#((TEC_2_PORT << 5 | TEC_2_PIN) << 2)]
    STR R0,[R1,#((TEC_3_PORT << 5 | TEC_3_PIN) << 2)]
    STR R0,[R1,#((TEC_4_PORT << 5 | TEC_4_PIN) << 2)]
    STR R0,[R1,#((TEC_A_PORT << 5 | TEC_A_PIN) << 2)]
    STR R0,[R1,#((TEC_C_PORT << 5 | TEC_C_PIN) << 2)]

    // Configura los pines de los digitos como gpio 
    MOV R0,#(SCU_MODE_INBUFF_EN | SCU_MODE_INACT | SCU_MODE_FUNC0)
    STR R0,[R1,#((DIG_1_PORT << 5 | DIG_1_PIN) << 2)]
    STR R0,[R1,#((DIG_2_PORT << 5 | DIG_2_PIN) << 2)]
    STR R0,[R1,#((DIG_3_PORT << 5 | DIG_3_PIN) << 2)]
    STR R0,[R1,#((DIG_4_PORT << 5 | DIG_4_PIN) << 2)]

    // Configura los pines de los segmentos como gpio 
    MOV R0,#(SCU_MODE_INBUFF_EN | SCU_MODE_INACT | SCU_MODE_FUNC0)
    STR R0,[R1,#((SEG_A_PORT << 5 | SEG_A_PIN) << 2)]
    STR R0,[R1,#((SEG_B_PORT << 5 | SEG_B_PIN) << 2)]
    STR R0,[R1,#((SEG_C_PORT << 5 | SEG_C_PIN) << 2)]
    STR R0,[R1,#((SEG_D_PORT << 5 | SEG_D_PIN) << 2)]
    STR R0,[R1,#((SEG_E_PORT << 5 | SEG_E_PIN) << 2)]
    STR R0,[R1,#((SEG_F_PORT << 5 | SEG_F_PIN) << 2)]
    STR R0,[R1,#((SEG_G_PORT << 5 | SEG_G_PIN) << 2)]
    MOV R0,#(SCU_MODE_INBUFF_EN | SCU_MODE_INACT | SCU_MODE_FUNC4)
    STR R0,[R1,#((SEG_DP_PORT << 5 | SEG_DP_PIN) << 2)]
    
    // Selecciono las cuatro teclas como fuente de interrupcion
    LDR R0,=(TECC << 8 | TECA << 0)
    STR R0,[R1,#PINTSEL0]  

    //Apago todos los bits gpio de los segmentos
    LDR R1,=GPIO_CLR0
    LDR R0,=SEG_N_MASK
    STR R0,[R1,#SEG_N_OFFSET]

    //Apago todos los bits gpio de los digitos
    LDR R1,=GPIO_CLR0
    LDR R0,=DIG_N_MASK
    STR R0,[R1,#DIG_N_OFFSET]

    //Apago todos los bits gpio de los digitos
    LDR R1,=GPIO_CLR0
    LDR R0,=SEG_N1_MASK
    STR R0,[R1,#SEG_N1_OFFSET]

    //Se configuran los bits gpio de los segmentos como como salidas
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#SEG_N_OFFSET]
    ORR R0,#SEG_N_MASK
    STR R0,[R1,#SEG_N_OFFSET]

    //Se configura el bit gpio del segmento DP como como salida
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#SEG_N1_OFFSET]
    ORR R0,#SEG_N1_MASK
    STR R0,[R1,#SEG_N1_OFFSET]

    //Se configuran los bits gpio de los digitos como salidas
    LDR R0,[R1,#DIG_N_OFFSET]
    ORR R0,#DIG_N_MASK
    STR R0,[R1,#DIG_N_OFFSET]

    // Configura los bits gpio de los botones como entradas
    LDR R0,[R1,#TEC_N_OFFSET]
    BIC R0,#TEC_N_MASK
    STR R0,[R1,#TEC_N_OFFSET]

    
    // Configuro los pines para operacion por flancos
    LDR R4,=PINT_BASE
    MOV R0,#0x00
    STR R0,[R4,#ISEL]
    MOV R0,#0xFF
    STR R0,[R4,#CIENF]  //Deshabilita flacos decenditens
//  STR R0,[R4,#CIENR]  //ceros en el IENR nivel 
    MOV R0,#0x03
    STR R0,[R4,#SIENR]  //Habilita flancos ascendentes
    MOV R0,#0x05
 //   STR R0,[R4,#SIENF]

   // Borro los pedidos pendientes de interrupciones del GPIO
    MOV R0,#0xFF
    STR R0,[R4,#IST]

    LDR R1,=NVIC_ICPR1
    MOV R0,0x0F
    STR R0,[R1]

    // Habilito los pedidos de interrupciones del GPIO en el NVIC
    LDR R1,=NVIC_ISER1
    MOV R0,0x0F
    STR R0,[R1]

    CPSIE I 

    // Define los punteros para usar en el programa
    LDR R4,=GPIO_PIN0
    LDR R5,=GPIO_NOT0
refrescar:

    B refrescar
    .pool
    .endfunc

//Funcion que llama al refresco de los displays, se podria hacer de otra manera, se deberia hacer de otra manera
    .func ref
ref:
    PUSH {R0-R6,LR}
    BL refrescar_displays
    POP {R0-R6,LR}
    BX LR
    .endfunc

    .func refrescar_displays
refrescar_displays:
    LDR R5,=d
    LDRB R6,[R5]
//Incrementa y reinicia variable de control
    ADD R6,#1
    CMP R6,#5
    IT EQ
    MOVEQ R6,0x00
    STRB R6,[R5]


    LDR R4,=GPIO_PIN0
    LDR R1,=tabla_refresco

//Enciende el display 1 
    CMP R6,#1
    ITTT    EQ
    LDREQ R0,=segundos
    LDRBEQ R2,[R0]
    MOVEQ R3,#DIG_1_MASK
//Enciende el display 2
    CMP R6,#2
    ITTT    EQ
    LDREQ R0,=segundos+1
    LDRBEQ R2,[R0]
    MOVEQ R3,#DIG_2_MASK
//Enciende el display 3
    CMP R6,#3
    ITTT    EQ
    LDREQ R0,=minutos
    LDRBEQ R2,[R0]
    MOVEQ R3,#DIG_3_MASK
//Enciende el display 4
    CMP R6,#4
    ITTT    EQ
    LDREQ R0,=minutos+1
    LDRBEQ R2,[R0]
    MOVEQ R3,#DIG_4_MASK

    LDR R2,[R1,R2,LSL #2] //Conversion



    STR   R2,[R4,#SEG_N_OFFSET]
    STR   R3,[R4,#DIG_N_OFFSET]
//Si esta en 3 prende el display, si no lo apaga (Siempre)
    CMP R6,#3
    IT EQ
    BEQ encender_punto
    BNE apagar_punto
fin_apagado:
fin_refrescar_displays:
    BX LR
encender_punto:
    LDR R4,=GPIO_PIN0
    MOV R2,#SEG_DP_MASK
    STR R2,[R4,#SEG_N1_OFFSET]
    B fin_apagado
//El punto se debe apagar cada vez que no deba estar encendido, si no no anda
apagar_punto:           
    LDR R1,=GPIO_CLR0
    MOV R0,#SEG_DP_MASK
    STR R0,[R1,#SEG_N1_OFFSET]
    B fin_apagado
    .endfunc

//Rutina de inicializacion del systick
    .func systick_init
systick_init:
    CPSID I                     // Se deshabilitan globalmente las interrupciones

    // Se sonfigura prioridad de la interrupcion
    LDR R1,=SHPR3               // Se apunta al registro de prioridades
    LDR R0,[R1]                 // Se cargan las prioridades actuales
    MOV R2,#2                   // Se fija la prioridad en 2
    BFI R0,R2,#29,#3            // Se inserta el valor en el campo
    STR R0,[R1]                 // Se actualizan las prioridades

    // Se habilita el SysTick con el reloj del nucleo
    LDR R1,=SYST_CSR
    MOV R0,#0x00
    STR R0,[R1]                 // Se quita el bit ENABLE
    //.1*10^9/20.83
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

//Rutina de interrupcion del systick
    .func systick_isr
systick_isr:                        
    LDR R0,=espera_refresco_display 
    LDR R1,[R0]
    SUB R1,#1
    CMP R1,0x00
    BEQ systick_llamada_refrescar_displays
    STRB R1,[R0] 
fin_llamada:
    LDR R0,=espera
    LDR R1,[R0]
    SUBS R1,#1
    BHI systick_exit
    PUSH {R0,R1,LR}
    BL actualizar_hora
    POP {R0,R1,LR}
    MOV R1,0x6E8                    //Valor obtenido experimentalmente, no entiendo el calculo, pero funciona
    systick_exit:
    STR R1,[R0]
    BX LR
systick_llamada_refrescar_displays:
    PUSH {R0-R6,LR}                 //Esto hace que ref este al pedo, que la borre otro y pruebe
    BL refrescar_displays
    POP {R0-R6,LR}
    MOV R1,0x5
    STR R1,[R0]
    B fin_llamada

    .pool
    .endfunc
//Rutina que actualiza hora, no hace falta explicar
    .func actualizar_hora
actualizar_hora:
    LDR R2,=activa
    LDRB R2,[R2]
    CMP R2,0x00
    BEQ actualizar_hora_inactivo

    LDR R0,=segundos
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

    LDR R0,=minutos
    LDRB R1,[R0]

    ADD R1,#1
    CMP R1,0xA
    BNE fin_actualizar_hora
    SUB R1,0xA
    STRB R1,[R0]

    LDRB R1,[R0,#1]!

    ADD R1,#1
    CMP R1,0x4
    BNE fin_actualizar_hora
    SUB R1,0x4
    STRB R1,[R0]

fin_actualizar_hora:
    STRB R1,[R0]
actualizar_hora_inactivo:
    BX LR
    .pool
    .endfunc

//Si ocurre int en IST 1 pausa el cronometro
//Si ocurre int en IST 2 reinicia el cronometro
    .func gpio_isr
gpio_isr:
    LDR R1,=PINT_BASE
    LDR R0,[R1,#IST]    //IST guarda en sus primeros 3 bits si hubo interrupciones
    STR R0,[R1,#IST]    //Si se escribe cualquier cosa en IST este se borra        

    TST R0,#2   
    IT NE
    BNE llamado_reiniciar_cronometro
    TST R0,#1
    IT NE
    BNE llamado_pausar_cronometro
fin_llamado_GPIO_isr:    
    BX LR
//Tuve problemas para hacerlo de otra forma, funciona, pero es poco eficiente diria Volentini
llamado_reiniciar_cronometro:
    PUSH {R0,R1,LR}
    BL reiniciar_cronometro
    POP {R0,R1,LR}
    B fin_llamado_GPIO_isr
llamado_pausar_cronometro:
    PUSH {R0,R1,LR}
    BL pausar_cronometro
    POP {R0,R1,LR}
    B fin_llamado_GPIO_isr
    .pool
    .endfunc
//Pone las variables minutos y segundos en 0
    .func reiniciar_cronometro
reiniciar_cronometro:
    MOV R0,0x00
    LDR R1,=segundos
    STRB R0,[R1]
    STRB R0,[R1,#1]!
    STRB R0,[R1,#1]!
    STRB R0,[R1,#1]!
    LDR R1,=activa
    STRB R0,[R1]
    BX LR
    .pool
    .endfunc

//Pausa el cronometro o lo pone en marcha
    .func pausar_cronometro
pausar_cronometro:
    LDR R0,=activa
    LDRB R1,[R0]
     CMP R1,0x01
     ITE EQ
     MOVEQ R1,0x00
     MOVNE R1,0x01
     STRB R1,[R0]
     BX LR
    .endfunc

//Funcion de servicio en la que termina siempre que cambias algo

    .func handler
handler:
    LDR R0,=set_led_1       // Apuntar al incio de una subrutina lejana
    BLX R0                  // Llamar a la rutina para encender el led rojo
    B handler               // Lazo infinito para detener la ejecucion
    .pool                   // Almacenar las constantes de codigo
    .endfunc