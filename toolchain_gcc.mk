## Name
##   toolchain_gcc.mk
##
## Purpose
##   GCC toolchain definitions
##
## Revision
##    30-Mar-2020 (SSB) [] Initial
##    02-Apr-2020 (SSB) [] Remove linker script location. It shall be defined
##                         in the project central makefile
##    03-Apr-2020 (SSB) [] Update LDFLAGS_DEBUG
##    19-Apr-2020 (SSB) [] Add CPU specific toolchain definitions
##    10-May-2020 (SSB) [] Add support for Cortex M7 CPU
##    24-Jan-2021 (SSB) [] File rename
##                         Refactoring, no functional impact

# Toolchain location
TOOLCHAIN_ROOT    ?= C:/gcc-arm-none-eabi
TARGET_TRIPLET    := arm-none-eabi
TOOLCHAIN_BIN_DIR := $(TOOLCHAIN_ROOT)/bin
TOOLCHAIN_INC_DIR := $(TOOLCHAIN_ROOT)/$(TARGET_TRIPLET)/include
TOOLCHAIN_LIB_DIR := $(TOOLCHAIN_ROOT)/$(TARGET_TRIPLET)/lib

# Tools location and definiton
CC     := $(TOOLCHAIN_BIN_DIR)/$(TARGET_TRIPLET)-gcc
LD     := $(TOOLCHAIN_BIN_DIR)/$(TARGET_TRIPLET)-ld
AR     := $(TOOLCHAIN_BIN_DIR)/$(TARGET_TRIPLET)-ar
AS     := $(TOOLCHAIN_BIN_DIR)/$(TARGET_TRIPLET)-as
OBJCPY := $(TOOLCHAIN_BIN_DIR)/$(TARGET_TRIPLET)-objcopy
OBJDMP := $(TOOLCHAIN_BIN_DIR)/$(TARGET_TRIPLET)-objdump
SIZE   := $(TOOLCHAIN_BIN_DIR)/$(TARGET_TRIPLET)-size

LDSCRIPT_EXTENSION := ld

# Common flags for all tools
TOOLCHAIN_FLAGS_COMMON := -mthumb \
                          -fmessage-length=0 \
                          -ffunction-sections \
                          -fdata-sections

TOOLCHAIN_FLAGS_M7 := -mcpu=cortex-m7 \
                      -mfloat-abi=hard \
                      -mfpu=fpv5-d16

TOOLCHAIN_FLAGS_M4 := -mcpu=cortex-m4 \
                      -mfloat-abi=hard \
                      -mfpu=fpv4-sp-d16 \

TOOLCHAIN_FLAGS_M3 := -mcpu=cortex-m3 \
                      -mabi=aapcs

# C standard
TOOLCHAIN_CSTANDARD := -std=gnu99

ASFLAGS :=

CFLAGS_DEBUG := -ggdb \
                -g3 \
                -Og

CFLAGS_RELEASE  := -Os

CFLAGS := -Wall \
          $(CFLAGS_$(call toupper,$(BUILD_TYPE))) \
          $(TOOLCHAIN_FLAGS_COMMON) \
          $(TOOLCHAIN_FLAGS_$(CPU_FAMILY)) \
          $(TOOLCHAIN_CSTANDARD)

ARFLAGS := -cr

LDFLAGS_DEBUG := -Og
                 # --specs=rdimon.specs \
                 # -lrdimon

LDFLAGS_RELEASE := --specs=nosys.specs

LDFLAGS      := -T$(LDSCRIPT).ld \
                -static \
                -Wl,-cref,-u,Reset_Handler \
                -Wl,-Map=$(BIN_DIR)/$(PROJECT_NAME).map \
                -Wl,--gc-sections \
                -Wl,--defsym=malloc_getpagesize_P=0x80 \
                -Wl,--start-group -lc -lm -Wl,--end-group \
                --specs=nano.specs \
                $(LDFLAGS_$(call toupper,$(BUILD_TYPE))) \
                $(TOOLCHAIN_FLAGS_COMMON) \
                $(TOOLCHAIN_FLAGS_$(CPU_FAMILY))

DEP_FLAGS += -MMD -MP -MF $(DEP_DIR)/$*.d

# Build artifacts
TARGET_ELF   := $(BIN_DIR)/$(PROJECT_NAME).elf
TARGET_BIN   := $(BIN_DIR)/$(PROJECT_NAME).bin
TARGET_HEX   := $(BIN_DIR)/$(PROJECT_NAME).hex

OBJCPY_BIN_FLAGS := -O binary
OBJCPY_HEX_FLAGS := -O ihex

# Use CC instead of LD for linking
LD := $(CC)