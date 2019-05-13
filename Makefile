CROSS_COMPILE = /opt/gcc-arm-none-eabi-7-2018-q2-update/bin/arm-none-eabi-

APP ?= AT_Slave

ROOTDIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CUBEDIR := $(ROOTDIR)/STM32CubeExpansion_LRWAN_V1.2.1
DRVDIR := $(CUBEDIR)/Drivers
CMWDIR := $(DRVDIR)/BSP/CMWX1ZZABZ-0xx
LORADIR := $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN

PRJDIR := $(CUBEDIR)/Projects/B-L072Z-LRWAN1/Applications/LoRa/$(APP)
APPDIR := $(PRJDIR)/LoRaWAN/App
COREDIR := $(PRJDIR)/Core

DRV_SRCS = $(CUBEDIR)/Drivers/BSP/B-L072Z-LRWAN1/b-l072z-lrwan1.c \
       $(CUBEDIR)/Drivers/BSP/CMWX1ZZABZ-0xx/mlm32l07x01.c \
       $(CUBEDIR)/Drivers/BSP/Components/sx1276/sx1276.c \
       $(CUBEDIR)/Drivers/CMSIS/Device/ST/STM32L0xx/Source/Templates/system_stm32l0xx.c \
       $(wildcard $(CUBEDIR)/Drivers/STM32L0xx_HAL_Driver/Src/*.c)

LORAWAN_SRCS = $(wildcard $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Crypto/*.c) \
       $(wildcard $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Mac/region/*.c) \
       $(wildcard $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Mac/*.c) \
       $(wildcard $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Utilities/*.c)
ifneq ($(APP),PingPong)
LORAWAN_SRCS += $(CUBEDIR)/Middlewares/Third_Party/LoRaWAN/Core/lora-test.c
endif

APP_SRCS = $(wildcard $(APPDIR)/src/*.c) \
	  $(wildcard $(COREDIR)/src/*.c)

STARTUP = $(PRJDIR)/SW4STM32/startup_stm32l072xx.s
LDSCRIPT = $(PRJDIR)/SW4STM32/mlm32l07x01/STM32L072CZYx_FLASH.ld

DRV_OBJS = $(DRV_SRCS:.c=.o)
LORAWAN_OBJS = $(LORAWAN_SRCS:.c=.o)
APP_OBJS = $(APP_SRCS:.c=.o) $(STARTUP:.s=.o)

DRV_LIB = drv.a
LORAWAN_LIB = lorawan.a
LIBS = $(DRV_LIB) $(LORAWAN_LIB)

CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)ld
OC = $(CROSS_COMPILE)objcopy
AR = $(CROSS_COMPILE)ar
RANLIB = $(CROSS_COMPILE)ranlib

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
	  -DLORAMAC_CLASSB_ENABLED \
	  -DUSE_MODEM_LORA
ifdef DEBUG
CFLAGS += -DDEBUG -g
else
CFLAGS += -O3
endif

LDFLAGS += -mcpu=cortex-m0plus -Wl,--gc-sections -static -specs=nano.specs -specs=nosys.specs
LDFLAGS += -T$(LDSCRIPT)

all: $(APP).hex

$(DRV_LIB): $(DRV_OBJS)
$(LORAWAN_LIB): $(LORAWAN_OBJS)

$(APP).elf: $(APP_OBJS) $(DRV_LIB) $(LORAWAN_LIB)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.s
	$(CC) $(CFLAGS) -c $< -o $@

%.a:
	$(AR) rv $@ $^
	$(RANLIB) $@

%.elf:
	$(CC) $(LDFLAGS) $^ -o $@

%.bin: %.elf
	$(OC) -Obinary $< $@

%.hex: %.elf
	$(OC) -Oihex $< $@

clean:
	-rm -f *.elf *.hex *.bin *.map $(LIBS) $(DRV_OBJS) $(LORAWAN_OBJS) $(APP_OBJS)
