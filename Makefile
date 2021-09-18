# Define a la accion de depuracion como objetivo predeterminado
.DEFAULT_GOAL := compilar

# Define a la memoria RAM como predeterminada
MEMORIA ?= RAM

-include proyecto.mk

PROYECTO ?= $(firstword $(filter %.s, $(MAKECMDGOALS)))
DESTINO = binarios/proyecto.elf
# DESTINO = $(patsubst %.s,binarios/%.elf,$(notdir $(PROYECTO)))
OBJETO = $(patsubst %.elf,%.o,$(DESTINO))
BINARIO = $(patsubst %.elf,%.bin,$(DESTINO))

# Determina el archivo de linker a utilizar en funcion de la memoria donde
# debe ejecutarse el programa: RAM o FLASH
ifeq ($(MEMORIA),FLASH)
LSCRIPT = ./configuraciones/lpc4337_flash.ld
else
LSCRIPT = ./configuraciones/lpc4337_ram.ld
endif

.PHONY: directorios
directorios:
	@mkdir -p binarios

clean: directorios
	-@rm -rf binarios/*.*

# Muestra información del proyecto y las configuraciones 
info:
	@echo $(LSCRIPT)

# Ensambla el archivo con el codigo fuente del proyecto
$(OBJETO): $(PROYECTO)
	@echo "Esamblando el codigo fuente del proyecto"
	@arm-none-eabi-as -g -o $@ $<

# Enlaza el archivo ensamblado del proyecto y asigna las sonzas de memoria
$(DESTINO): $(OBJETO)
	@echo "Enlazando el codigo fuente del proyecto"
	@arm-none-eabi-ld -T $(LSCRIPT) -M -o $@ $< > $(patsubst %.elf,%.map,$(DESTINO))

compilar: clean $(DESTINO)
	@arm-none-eabi-objdump -d $(DESTINO) > $(patsubst %.elf,%.lst,$(DESTINO))

$(BINARIO): $(DESTINO)
	@arm-none-eabi-objcopy -j .text* -O binary $(DESTINO) $(BINARIO)

download: compilar $(BINARIO)
	@openocd -f ./configuraciones/ciaa-nxp.cfg -c "init" -c "halt 0" -c "flash write_image erase unlock $(BINARIO) 0x1A000000 bin" -c "reset run" -c "shutdown"

preparar:
	@echo "Preparando la placa para ejecucion de programas en RAM"
	@make download PROYECTO=./configuraciones/isr_ram.s MEMORIA=FLASH 
