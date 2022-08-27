// Quevedo, Franco
// 39.733.942

/****************************************************************************/
/* Macros para acceso simbolico a los recursos de la placa base edu-ciaa-nxp
/****************************************************************************/

// Recursos utilizados por el canal Rojo del led RGB
    // Numero de puerto de entrada/salida utilizado en el Led Rojo
    .equ LED_R_PORT,    2
    // Numero de terminal dentro del puerto de e/s utilizado en el Led Rojo
    .equ LED_R_PIN,     0
    // Numero de bit GPIO utilizado en el Led Rojo
    .equ LED_R_BIT,     0
    // Mascara de 32 bits con un 1 en el bit correspondiente al Led Rojo
    .equ LED_R_MASK,    (1 << LED_R_BIT)

// Recursos utilizados por el canal Verde del led RGB
    .equ LED_G_PORT,    2
    .equ LED_G_PIN,     1
    .equ LED_G_BIT,     1
    .equ LED_G_MASK,    (1 << LED_G_BIT)

// Recursos utilizados por el canal Azul del led RGB
    .equ LED_B_PORT,    2
    .equ LED_B_PIN,     2
    .equ LED_B_BIT,     2
    .equ LED_B_MASK,    (1 << LED_B_BIT)

// Recursos utilizados por el led RGB
    // Numero de puerto GPIO utilizado por los todos leds
    .equ LED_RGB_GPIO,      5
    // Desplazamiento para acceder a los registros GPIO de los leds
    .equ LED_RGB_OFFSET,    ( 4 * LED_RGB_GPIO )
    // Mascara de 32 bits con un 1 en los bits correspondiente a cada led
    .equ LED_RGB_MASK,      ( LED_R_MASK | LED_G_MASK | LED_B_MASK )

// --------------------------------------------------------------------------

// Recursos utilizados por el led 1 (está en un GPIO distinto)
    .equ LED_1_PORT,    2
    .equ LED_1_PIN,     10
    .equ LED_1_BIT,     14
    .equ LED_1_MASK,    (1 << LED_1_BIT)

    .equ LED_1_GPIO,    0
    .equ LED_1_OFFSET,  ( LED_1_GPIO << 2)

// Recursos utilizados por el led 2
    .equ LED_2_PORT,    2
    .equ LED_2_PIN,     11
    .equ LED_2_BIT,     11
    .equ LED_2_MASK,    (1 << LED_2_BIT)

// Recursos utilizados por el led 3
    .equ LED_3_PORT,    2
    .equ LED_3_PIN,     12
    .equ LED_3_BIT,     12
    .equ LED_3_MASK,    (1 << LED_3_BIT)

// Recursos utilizados por los leds 2 y 3
    .equ LED_N_GPIO,    1
    .equ LED_N_OFFSET,  ( LED_N_GPIO << 2)
    .equ LED_N_MASK,    ( LED_2_MASK | LED_3_MASK )

// --------------------------------------------------------------------------

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
    .equ TEC_OFFSET,    ( TEC_GPIO << 2)
    .equ TEC_MASK,      ( TEC_1_MASK | TEC_2_MASK | TEC_3_MASK )
