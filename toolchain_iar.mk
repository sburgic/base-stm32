## Name
##   toolchain_iar.mk
##
## Purpose
##   IAR toolchain definitions
##
## Revision
##    29-Dec-2020 (SSB) [] Initial
##    25-Jan-2021 (SSB) [] Add support for Cortex M7 CPUs

# Toolchain location
TOOLCHAIN_ROOT ?= C:/iar_8.50.6/arm

# Tools location and definiton
CC     := $(TOOLCHAIN_ROOT)/bin/iccarm.exe
LD     := $(TOOLCHAIN_ROOT)/bin/ilinkarm.exe
AR     := $(TOOLCHAIN_ROOT)/bin/iarchive.exe
AS     := $(TOOLCHAIN_ROOT)/bin/iasmarm.exe
OBJCPY := $(TOOLCHAIN_ROOT)/bin/ielftool.exe

CFLAGS_M3 := --cpu=Cortex-M3
CFLAGS_M7 := --cpu=Cortex-M7

# Archiver flags
ARFLAGS := --create

# Linker flags
LDFLAGS := 

# Assembler flags
ASFLAGS :=

# Compiler flags
CFLAGS := --endian=little \
          -e \
          --fpu=None \
          --dlib_config $(TOOLCHAIN_ROOT)/inc/c/DLib_Config_Full.h \
          --error_limit=1 \
          --use_unix_directory_separators \
          --use_c++_inline \
          --require_prototypes \
          --silent

# Build type modifiers
CFLAGS_DEBUG    := --debug \
                   -Ol
LDFLAGS_DEBUG   := 
CFLAGS_RELEASE  := -Ohs
LDFLAGS_RELEASE :=

CFLAGS  += $(CFLAGS_$(call toupper,$(BUILD_TYPE))) \
           $(CFLAGS_$(CPU_FAMILY))

LDFLAGS += $(LDFLAGS_$(call toupper,$(BUILD_TYPE))) \
           --config $(LDSCRIPT).icf \
           --semihosting \
           --entry __iar_program_start \
           --vfe \
           --text_out locale \
           --redirect _Printf=_PrintfSmall \
           --redirect _Scanf=_ScanfSmall \
           --no_out_extension \
           --map $(BIN_DIR)/$(PROJECT_NAME).map

OBJCPY_BIN_FLAGS := --bin
OBJCPY_HEX_FLAGS := --ihex

DEP_FLAGS += --dependencies=m $(DEP_DIR)/$*.d

# Build artifacts
TARGET_ELF   := $(BIN_DIR)/$(PROJECT_NAME).elf
TARGET_BIN   := $(BIN_DIR)/$(PROJECT_NAME).bin
TARGET_HEX   := $(BIN_DIR)/$(PROJECT_NAME).hex
