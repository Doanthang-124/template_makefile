# edit: dvThang124


PRO_DIR := .
PROJ_NAME	:= template_makefile
OUTPUT_PATH := $(PRO_DIR)/output

INC_DIR := $(PRO_DIR)/drivers
SRC_DIR := $(PRO_DIR)/src
LINKER_FILE	:= $(PRO_DIR)/linker/stm32_flash.ld

# list of source files
SOURCES  = $(SRC_DIR)/main.c
SOURCES += $(SRC_DIR)/stm32f10x_rcc.c
SOURCES += $(SRC_DIR)/system_stm32f10x.c
SOURCES += $(SRC_DIR)/stm32f10x_gpio.c
SOURCES += $(PRO_DIR)/startup_stm32f10x_md.s


# compiler, objcopy (should be in PATH)
COMP_DIR := C:/GNUArmEmbeddedToolchain/102021.10
CC = $(COMP_DIR)/bin/arm-none-eabi-gcc
OBJCOPY = $(COMP_DIR)/arm-none-eabi/bin/objcopy

# path to st-flash (or should be specified in PATH)
ST_FLASH ?= st-flash

# specify compiler flags
CFLAGS  = -g -O2 -Wall
CFLAGS += -T$(LINKER_FILE)
CFLAGS += -mlittle-endian -mthumb -mcpu=cortex-m4 -mthumb-interwork
CFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16
CFLAGS += -DSTM32F10X_MD -DUSE_STDPERIPH_DRIVER
CFLAGS += -Wl,--gc-sections
CFLAGS += -I.
CFLAGS += -I$(INC_DIR)/CMSIS/CM3/CoreSupport
CFLAGS += -I$(INC_DIR)/STM32F10x_StdPeriph_Driver/inc 
CFLAGS += -I$(INC_DIR)/CMSIS/CM3/DeviceSupport/ST/STM32F10x/

OBJS = $(SOURCES:.c=.o)

all: $(OUTPUT_PATH)/$(PROJ_NAME).elf

# compile
$(OUTPUT_PATH)/$(PROJ_NAME).elf: $(SOURCES)
	$(CC) $(CFLAGS) $^ -o $@
	$(OBJCOPY) -O ihex $(OUTPUT_PATH)/$(PROJ_NAME).elf $(OUTPUT_PATH)/$(PROJ_NAME).hex
	$(OBJCOPY) -O binary $(OUTPUT_PATH)/$(PROJ_NAME).elf $(OUTPUT_PATH)/$(PROJ_NAME).bin

# remove binary files
clean:
	@rm -rf $(OUTPUT_PATH)/*

# flash
burn:
	sudo $(ST_FLASH) write $(PROJ_NAME).bin 0x8000000
