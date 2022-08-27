    .cpu 	cortex-m4       // Indica el procesador de destino  
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"

/* Definición de macros ***********************************************/
    
    // Recursos utilizados por el canal Rojo del Led RGB
    .equ LED_R_PORT,    2                   // N° de puerto de entrada/salida utilizado en el Led Rojo
    .equ LED_R_PIN,     0                   // N° de terminal dentro del puerto de E/S utilizado en el Led Rojo
    .equ LED_R_BIT,     0                   // N° de bit GPIO utilizado en el Led Rojo
    .equ LED_R_MASK,    (1 << LED_R_BIT)    // Mascara de 32 bits con un 1 en el bit correspondiente al Led Rojo

    // Recursos utilizados por el canal Verde del Led RGB
    .equ LED_G_PORT,    2
    .equ LED_G_PIN,     1
    .equ LED_G_BIT,     1
    .equ LED_G_MASK,    (1 << LED_G_BIT)

    //Recursos utilizados por el canal Azul del Led RGB
    .equ LED_B_PORT,    2
    .equ LED_B_PIN,     2
    .equ LED_B_BIT,     2
    .equ LED_B_MASK,    (1 << LED_B_BIT)
    
    // Recursos utilizados por el Led RGB
    .equ LED_GPIO,      5                   // N° de puerto GPIO utilizado por todos los leds
    .equ LED_OFFSET,    ( 4 * LED_GPIO )    // Desplazamiento para acceder a los registros GPIO de los leds
    // Mascara de 32 bits con un 1 en los bits correspondientes a cada led
    .equ LED_MASK,      ( LED_R_MASK | LED_G_MASK | LED_B_MASK )

    // -------------------------------------------------------------------------
    // Recursos utilizados por el Led 1 (Está en un GPIO distinto)
    .equ LED_1_PORT,    2
    .equ LED_1_PIN,     10
    .equ LED_1_BIT,     14
    .equ LED_1_MASK,    (1 << LED_1_BIT)

    .equ LED_1_GPIO,    0
    .equ LED_1_OFFSET,  (LED_1_GPIO << 2)

    // Recursos utilizados por el Led 2
    .equ LED_2_PORT,    2
    .equ LED_2_PIN,     11
    .equ LED_2_BIT,     11
    .equ LED_2_MASK,    (1 << LED_2_BIT)

    // Recursos utilizados por el Led 3
    .equ LED_3_PORT,    2
    .equ LED_3_PIN,     12
    .equ LED_3_BIT,     12
    .equ LED_3_MASK,    (1 << LED_3_BIT)

    // Recursos utilizados por los Leds 2 y 3
    .equ LED_N_GPIO,    1
    .equ LED_N_OFFSET,  ( LED_N_GPIO << 2 )
    .equ LED_N_MASK,    ( LED_2_MASK | LED_3_MASK )

    // -------------------------------------------------------------------------
    // Recursos utilizados por la 1ra tecla
    .equ TEC_1_PORT,    1
    .equ TEC_1_PIN,     0
    .equ TEC_1_BIT,     4
    .equ TEC_1_MASK,    (1 << TEC_1_BIT)

    // Recursos utilizados por la 2da tecla
    .equ TEC_2_PORT,    1
    .equ TEC_2_PIN,     1
    .equ TEC_2_BIT,     8
    .equ TEC_2_MASK,    (1 << TEC_2_BIT)

    // Recursos utilizados por la 3ra tecla
    .equ TEC_3_PORT,    1
    .equ TEC_3_PIN,     2
    .equ TEC_3_BIT,     9
    .equ TEC_3_MASK,    (1 << TEC_3_BIT)

    // Recursos utilizados por las 3 teclas
    .equ TEC_GPIO,      0
    .equ TEC_OFFSET,    ( TEC_GPIO << 2 )
    .equ TEC_MASK,      ( TEC_1_MASK | TEC_2_MASK | TEC_3_MASK )

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
    .word   systick_isr+1   // 15: System tick service routine
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

    // Llama a una subrutina para configurar el systick
    BL  systick_init

    LDR R1,=SCU_BASE
    
    // Configura los pines de los leds RGB como GPIO s/pull-up F4
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    MOV R3,#(4 * (32 * LED_R_PORT + LED_R_PIN))
    STR R0,[R1,#(4 * (32 * LED_R_PORT + LED_R_PIN))]
    STR R0,[R1,#(4 * (32 * LED_G_PORT + LED_G_PIN))]
    STR R0,[R1,#(4 * (32 * LED_B_PORT + LED_B_PIN))]

    // Configura los pines de los leds 1 al 3 como GPIO s/pull-up F0
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(LED_1_PORT << 7 | LED_1_PIN << 2)]
    STR R0,[R1,#(LED_2_PORT << 7 | LED_2_PIN << 2)]
    STR R0,[R1,#(LED_3_PORT << 7 | LED_3_PIN << 2)]
    
    // Configura los pines de las teclas como GPIO c/pull-up(?) creo que es pull-down F0
    MOV R0,#(SCU_MODE_PULLDOWN | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#((TEC_1_PORT << 5 | TEC_1_PIN) << 2)]
    STR R0,[R1,#((TEC_2_PORT << 5 | TEC_2_PIN) << 2)]
    STR R0,[R1,#((TEC_3_PORT << 5 | TEC_3_PIN) << 2)]

    // Apaga todos los bits GPIO de los led RGB
    LDR R1,=GPIO_CLR0
    LDR R0,=LED_MASK
    STR R0,[R1,#LED_OFFSET]
    // Se apagan los bits GPIO de los leds 1 al 3
    LDR R0,=LED_1_MASK
    STR R0,[R1,#LED_1_OFFSET]
    LDR R0,=LED_N_MASK
    STR R0,[R1,#LED_N_OFFSET]

    // Configuro los bits GPIO de los leds RGB como salidas
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#LED_OFFSET]
    ORR R0,#LED_MASK
    STR R0,[R1,#LED_OFFSET]
    // Configuro los bits GPIO de los leds 1 al 3 como salidas
    LDR R0,=LED_1_MASK
    STR R0,[R1,#LED_1_OFFSET]
    LDR R0,=LED_N_MASK
    STR R0,[R1,#LED_N_OFFSET]

    // Configuro los bits GPIO de las teclas como entradas
    LDR R0,[R1,#TEC_OFFSET]
    BIC R0,#TEC_MASK
    STR R0,[R1,#TEC_OFFSET]

    // Define los punteros para usar el programa
    LDR R4,=GPIO_PIN0
    LDR R5,=GPIO_NOT0

// Verifico por polling si se tocó alguna tecla
@ refrescar:
@     MOV     R3,#0x00                // Define el estado actual de los leds como todos apagados
@     LDR     R0,[R4,#TEC_OFFSET]     // Carga el estado actual de las teclas

@     TST     R0,#TEC_1_MASK          // Verifica el estado del bit correspondiente a la tecla 1
@     IT      EQ                      // Si la tecla está apretada
@     ORREQ   R3,#LED_R_MASK          // Enciende el bit del canal Rojo del led RGB

@     // Enciende el bit del canal Verde del led RGB si la tecla 2 está apretada
@     TST     R0,#TEC_2_MASK
@     IT      EQ
@     ORREQ   R3,#LED_G_MASK

@     // Enciende el bit del canal Azul del led RGB si la tecla 3 está apretada
@     TST     R0,#TEC_3_MASK
@     IT      EQ
@     ORREQ   R3,#LED_B_MASK

@     STR     R3,[R4,#LED_OFFSET]     // Actualiza las salidas con el estado definido para los leds

@     B refrescar

stop:
    B stop
    
    .pool                   // Almacenar las constantes de codigo
    .endfunc

/* Rutina de inicialización de Systick *********************************************/
    .func systick_init
systick_init:
    CPSID I                 // Se deshabilitan globalmente las interrupciones

    // Se configura la prioridad de la interrupcion
    LDR R1,=SHPR3           // Se apunta al registro de prioridades
    LDR R0,[R1]             // Se cargan las prioridades actuales
    MOV R2,#2               // Se fija la prioridad en 2
    BFI R0,R2,#29,#3        // Se inserta el valor en el campo correspondiente
    STR R0,[R1]             // Se actualizan las prioridades

    // Se deshabilita el SysTick con el reloj del nucleo
    LDR R1,=SYST_CSR
    MOV R0,#0x00
    STR R0,[R1]             // Se quita el bit ENABLE

    // Se configura el desborde para un periodo de 100ms
    // EL SysTick cuando desborda (vuelve a 0) produce la interrupcion
    LDR R1,=SYST_RVR
    LDR R0,=#(4800000-1)
    STR R0,[R1]             // Se especifica el valor de RELOAD

    // Se inicializa el valor actual del contador
    LDR R1,=SYST_CVR
    MOV R0,#0               // Escribir cualquier valor limpia el contador
    STR R0,[R1]             // Se limpia COUNTER y flag COUNT

    // Se habilita el SysTick con el reloj del nucleo
    LDR R1,=SYST_CSR
    MOV R0,#0x07            // 0000.0111
    STR R0,[R1]             // Se fijan ENABLE, TICKINT y CLOCK_SRC

    CPSIE I                 // Se habilitan globalmente las interrupciones
    BX  LR                  // Se retorna al programa principa
    .pool                   // Almacenar las constantes de codigo
    .endfunc

/* Rutina de servicio para la interrupcion del Systick *********************************************/
    .func systick_isr
systick_isr:
    LDR  R0,=espera             // Se apunta R0 a la variable global espera
    LDRB R1,[R0]                // Se carga el valor de espera
    SUBS R1,#1                  // Se decrementa el valor de espera con flag
    BHI  systick_exit           // Si espera > 0 entonces no pasaron 10 iteraciones
    LDR  R1,=GPIO_NOT0          // Se apunta a la base de registros NOT
    MOV  R0,#LED_1_MASK         // Se carga la mascara para el LED 1
    STR  R0,[R1,#LED_1_OFFSET]  // Se invierte el bit GPIO del LED 1
    @ LDR  R1,=10000000                 // Se recarga la espera con 10 iteraciones
    LDR  R1,=10                 // Se recarga la espera con 10 iteraciones

systick_exit:
    STRB R1,[R0]            // Se actualiza la variable espera

    BX   LR                 // Se retorna al programa principa
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
