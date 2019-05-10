CROSS_COMPILE = /opt/gcc-arm-none-eabi-7-2018-q2-update/bin/arm-none-eabi-

ROOTDIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CUBEDIR := $(ROOTDIR)/STM32CubeExpansion_LRWAN_V1.2.1
DRVDIR := $(CUBEDIR)/Drivers
CMWDIR := $(DRVDIR)/BSP/CMWX1ZZABZ-0xx
LORADIR := $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN
PRJDIR := $(CUBEDIR)/Projects/B-L072Z-LRWAN1/Applications/LoRa/AT_Slave
APPDIR := $(PRJDIR)/LoRaWAN/App
COREDIR := $(PRJDIR)/Core

ELF = lora.elf
BIN = $(ELF:.elf=.bin)
HEX = $(ELF:.elf=.hex)

SRCS = $(CUBEDIR)/Drivers/BSP/B-L072Z-LRWAN1/b-l072z-lrwan1.c \
       $(CUBEDIR)/Drivers/BSP/CMWX1ZZABZ-0xx/mlm32l07x01.c \
       $(CUBEDIR)/Drivers/BSP/Components/sx1276/sx1276.c \
       $(CUBEDIR)/Drivers/CMSIS/Device/ST/STM32L0xx/Source/Templates/system_stm32l0xx.c \
       $(CUBEDIR)/Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal.c \
       $(CUBEDIR)/Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_adc.c \
       $(CUBEDIR)/Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_adc_ex.c \
       $(CUBEDIR)/Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_cortex.c \
       $(CUBEDIR)/Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_dma.c \
       $(CUBEDIR)/Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_flash.c \
       $(CUBEDIR)/Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_flash_ex.c \
       $(CUBEDIR)/Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_gpio.c \
       $(CUBEDIR)/Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_pwr.c \
       $(CUBEDIR)/Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_pwr_ex.c \
       $(CUBEDIR)/Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_rcc.c \
       $(CUBEDIR)/Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_rcc_ex.c \
       $(CUBEDIR)/Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_rtc.c \
       $(CUBEDIR)/Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_rtc_ex.c \
       $(CUBEDIR)/Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_spi.c \
       $(CUBEDIR)/Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_uart.c \
       $(CUBEDIR)/Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_uart_ex.c \
       $(CUBEDIR)/Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_hal_usart.c \
       $(CUBEDIR)/Drivers/STM32L0xx_HAL_Driver/Src/stm32l0xx_ll_dma.c \
       $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Core/lora-test.c \
       $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Crypto/aes.c \
       $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Crypto/cmac.c \
       $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Crypto/soft-se.c \
       $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Mac/region/Region.c \
       $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Mac/region/RegionAS923.c \
       $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Mac/region/RegionAU915.c \
       $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Mac/region/RegionCN470.c \
       $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Mac/region/RegionCN779.c \
       $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Mac/region/RegionCommon.c \
       $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Mac/region/RegionEU433.c \
       $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Mac/region/RegionEU868.c \
       $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Mac/region/RegionIN865.c \
       $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Mac/region/RegionKR920.c \
       $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Mac/region/RegionRU864.c \
       $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Mac/region/RegionUS915.c \
       $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Mac/LoRaMac.c \
       $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Mac/LoRaMacAdr.c \
       $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Mac/LoRaMacClassB.c \
       $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Mac/LoRaMacCommands.c \
       $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Mac/LoRaMacConfirmQueue.c \
       $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Mac/LoRaMacCrypto.c \
       $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Mac/LoRaMacFCntHandler.c \
       $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Mac/LoRaMacParser.c \
       $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Mac/LoRaMacSerializer.c \
       $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Utilities/low_power_manager.c \
       $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Utilities/queue.c \
       $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Utilities/systime.c \
       $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Utilities/timeServer.c \
       $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Utilities/trace.c \
       $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Utilities/utilities.c \
       $(APPDIR)/src/at.c \
       $(APPDIR)/src/command.c \
       $(APPDIR)/src/debug.c \
       $(APPDIR)/src/hw_gpio.c \
       $(APPDIR)/src/hw_rtc.c \
       $(APPDIR)/src/hw_spi.c \
       $(APPDIR)/src/lora.c \
       $(APPDIR)/src/main.c \
       $(COREDIR)/src/mlm32l0xx_hal_msp.c \
       $(COREDIR)/src/mlm32l0xx_hw.c \
       $(COREDIR)/src/mlm32l0xx_it.c \
       $(APPDIR)/src/test_rf.c \
       $(APPDIR)/src/tiny_sscanf.c \
       $(APPDIR)/src/tiny_vsnprintf.c \
       $(APPDIR)/src/vcom.c \

STARTUP = $(PRJDIR)/SW4STM32/startup_stm32l072xx.s
LDSCRIPT = $(PRJDIR)/SW4STM32/mlm32l07x01/STM32L072CZYx_FLASH.ld

OBJS = $(SRCS:.c=.o) $(STARTUP:.s=.o)

CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)ld
OC = $(CROSS_COMPILE)objcopy

CFLAGS +=  -mcpu=cortex-m0plus -DARM_MATH_CM0 -ffunction-sections -fdata-sections -specs=nano.specs -specs=nosys.specs
CFLAGS += -Wall -std=gnu99

CFLAGS += -I$(COREDIR)/inc -I$(DRVDIR)/BSP/B-L072Z-LRWAN1 -I$(DRVDIR)/STM32L0xx_HAL_Driver/Inc \
	 -I$(DRVDIR)/BSP/Components/sx1276 -I$(CMWDIR) -I$(APPDIR)/inc \
	 -I$(DRVDIR)/CMSIS/Device/ST/STM32L0xx/Include/ -I$(DRVDIR)/CMSIS/Include \
	 -I$(LORADIR)/Utilities -I$(LORADIR)/Mac -I$(LORADIR)/Phy -I$(LORADIR)/Core -I$(LORADIR)/Crypto

CFLAGS += -DSTM32L072xx \
	  -DUSE_B_L072Z_LRWAN1 \
	  -DUSE_FULL_LL_DRIVER \
	  -DREGION_EU868 \
	  -DLORAMAC_CLASSB_ENABLED
ifdef DEBUG
CFLAGS += -DDEBUG -g
else
CFLAGS += -O3
endif

LDFLAGS += -mcpu=cortex-m0plus -Wl,--gc-sections -static -specs=nano.specs -specs=nosys.specs
LDFLAGS += -T$(LDSCRIPT)

all: $(ELF) $(HEX)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.s
	$(CC) $(CFLAGS) -c $< -o $@

%.bin: %.elf
	$(OC) -Obinary $< $@

%.hex: %.elf
	$(OC) -Oihex $< $@

$(ELF): $(OBJS)
	$(CC) $(LDFLAGS) $^ -o $@

clean:
	-rm -f $(OBJS)
	-rm -f $(ELF)
	-rm -f $(BIN)
