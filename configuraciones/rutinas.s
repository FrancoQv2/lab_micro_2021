/* Copyright 2016, Laboratorio de Microprocesadores 
 * Facultad de Ciencias Exactas y Tecnología 
 * Universidad Nacional de Tucuman
 * http://www.microprocesadores.unt.edu.ar/
 * Copyright 2016, Esteban Volentini <evolentini@gmail.com>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its
 *    contributors may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */
    .equ rutinas,           0x1A000100 + 1
    .equ leds_init,         rutinas

    .equ set_led_r,         rutinas + 0x006C
    .equ clear_led_r,       rutinas + 0x007C
    .equ toggle_led_r,      rutinas + 0x008C

    .equ set_led_g,         rutinas + 0x009C
    .equ clear_led_g,       rutinas + 0x00AC
    .equ toggle_led_g,      rutinas + 0x00BC

    .equ set_led_b,         rutinas + 0x00CC
    .equ clear_led_b,       rutinas + 0x00DC
    .equ toggle_led_b,      rutinas + 0x00EC

    .equ set_led_1,         rutinas + 0x00FC
    .equ clear_led_1,       rutinas + 0x010C
    .equ toggle_led_1,      rutinas + 0x011C

    .equ set_led_2,         rutinas + 0x012C
    .equ clear_led_2,       rutinas + 0x013C
    .equ toggle_led_2,      rutinas + 0x014C

    .equ set_led_3,         rutinas + 0x015C
    .equ clear_led_3,       rutinas + 0x016C
    .equ toggle_led_3,      rutinas + 0x017C

    .equ inicio,            rutinas + 0x01a4
    .equ escaneo,           rutinas + 0x02c0
    .equ enviar,            rutinas + 0x033c
