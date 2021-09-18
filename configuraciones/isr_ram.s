    .cpu cortex-m4          // Indica el procesador de destino  
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"

/**
 * Vector de interrupciones
 */
    .section .isr_vector
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
    .word   handler+1      // 15: System tick service routine
    .word   handler+1       // 16: Interrupt IRQ service routine

/**
 * Rutina de inicializacion del GPIO de leds
 */
    .section .text
    .func leds_init
leds_init:
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    LDR R1,=SCU_SFSP2_0
    STR R0,[R1],#4
    STR R0,[R1],#4
    STR R0,[R1],#4

    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    LDR R1,=SCU_SFSP2_10
    STR R0,[R1],#4
    STR R0,[R1],#4
    STR R0,[R1],#4

    MOV R0,#(1 << 2 | 1 << 1 | 1 << 0)
    LDR R1,=(GPIO_CLR5)
    STR R0,[R1]
    LDR R1,=(GPIO_DIR5)
    STR R0,[R1]

    MOV R0,#(1 << 14)
    LDR R1,=(GPIO_CLR0)
    STR R0,[R1]
    LDR R1,=(GPIO_DIR0)
    STR R0,[R1]

    MOV R0,#(1 << 12 | 1 << 11)
    LDR R1,=(GPIO_CLR1)
    STR R0,[R1]
    LDR R1,=(GPIO_DIR1)
    STR R0,[R1]

    BX LR
    .pool
    .endfunc

/**
 * Rutinas de control para el canal R del led RGB
 */
    .func set_led_r
set_led_r:
    MOV R0,#(1 << 0)
    LDR R1,=(GPIO_SET5)
    STR R0,[R1]
    BX LR
    .pool
    .endfunc

    .func clear_led_r
clear_led_r:
    MOV R0,#(1 << 0)
    LDR R1,=(GPIO_CLR5)
    STR R0,[R1]
    BX LR
    .pool
    .endfunc

    .func toggle_led_r
toggle_led_r:
    MOV R0,#(1 << 0)
    LDR R1,=(GPIO_NOT5)
    STR R0,[R1]
    BX LR
    .pool
    .endfunc

/**
 * Rutina de control para el canal G del led RGB
 */
    .func set_led_g
set_led_g:
    MOV R0,#(1 << 1)
    LDR R1,=(GPIO_SET5)
    STR R0,[R1]
    BX LR
    .pool
    .endfunc

    .func clear_led_g
clear_led_g:
    MOV R0,#(1 << 1)
    LDR R1,=(GPIO_CLR5)
    STR R0,[R1]
    BX LR
    .pool
    .endfunc

    .func toggle_led_g
toggle_led_g:
    MOV R0,#(1 << 1)
    LDR R1,=(GPIO_NOT5)
    STR R0,[R1]
    BX LR
    .pool
    .endfunc

/**
 * Rutina de control para el canal B del led RGB
 */
    .func set_led_b
set_led_b:
    MOV R0,#(1 << 2)
    LDR R1,=(GPIO_SET5)
    STR R0,[R1]
    BX LR
    .pool
    .endfunc

    .func clear_led_b
clear_led_b:
    MOV R0,#(1 << 2)
    LDR R1,=(GPIO_CLR5)
    STR R0,[R1]
    BX LR
    .pool
    .endfunc

    .func toggle_led_b
toggle_led_b:
    MOV R0,#(1 << 2)
    LDR R1,=(GPIO_NOT5)
    STR R0,[R1]
    BX LR
    .pool
    .endfunc

/**
 * Rutina de control para el led 1
 */
    .func set_led_1
set_led_1:
    MOV R0,#(1 << 14)
    LDR R1,=(GPIO_SET0)
    STR R0,[R1]
    BX LR
    .pool
    .endfunc

    .func clear_led_1
clear_led_1:
    MOV R0,#(1 << 14)
    LDR R1,=(GPIO_CLR0)
    STR R0,[R1]
    BX LR
    .pool
    .endfunc

    .func toggle_led_1
toggle_led_1:
    MOV R0,#(1 << 14)
    LDR R1,=(GPIO_NOT0)
    STR R0,[R1]
    BX LR
    .pool
    .endfunc

/**
 * Rutina de control para el led 2
 */
    .func set_led_2
set_led_2:
    MOV R0,#(1 << 11)
    LDR R1,=(GPIO_SET1)
    STR R0,[R1]
    BX LR
    .pool
    .endfunc

    .func clear_led_2
clear_led_2:
    MOV R0,#(1 << 11)
    LDR R1,=(GPIO_CLR1)
    STR R0,[R1]
    BX LR
    .pool
    .endfunc

    .func toggle_led_2
toggle_led_2:
    MOV R0,#(1 << 11)
    LDR R1,=(GPIO_NOT1)
    STR R0,[R1]
    BX LR
    .pool
    .endfunc

/**
 * Rutina de control para el led 3
 */
    .func set_led_3
set_led_3:
    MOV R0,#(1 << 12)
    LDR R1,=(GPIO_SET1)
    STR R0,[R1]
    BX LR
    .pool
    .endfunc

    .func clear_led_3
clear_led_3:
    MOV R0,#(1 << 12)
    LDR R1,=(GPIO_CLR1)
    STR R0,[R1]
    BX LR
    .pool
    .endfunc

    .func toggle_led_3
toggle_led_3:
    MOV R0,#(1 << 12)
    LDR R1,=(GPIO_NOT1)
    STR R0,[R1]
    BX LR
    .pool
    .endfunc
/**
 * Handler por defecto para manejo de excepciones
 */
    .func handler
handler:
    BL leds_init
    BL set_led_1
loop:
    B loop
    .pool
    .endfunc

/**
 * Handler para el manejo del arranque
 */
    .global reset
    .func reset 
reset:
    BL leds_init
    LDR LR,=0x10000001
    BX LR

    .pool
    .endfunc
