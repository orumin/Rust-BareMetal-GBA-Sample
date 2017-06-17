#
# Makefile
# kotetuco, 2017
#

.PHONY: clean default mb rom
.SUFFIXES: .o .S

prefix := arm-none-eabi
AS := $(prefix)-as
LD := $(prefix)-ld
OBJCOPY := $(prefix)-objcopy
XARGO := $(shell which xargo)

TARGET_ARCH_RUST := $(prefix)

BUILD_NAME := rom
BUILD_DIR := build
BUILD_MODE := debug

TARGET_ROM_ELF := $(BUILD_DIR)/$(BUILD_NAME).elf
TARGET_MB_ELF := $(BUILD_DIR)/$(BUILD_NAME)_mb.elf
TARGET_ROM := $(BUILD_DIR)/$(BUILD_NAME).gba
TARGET_MB := $(BUILD_DIR)/$(BUILD_NAME).mb

CRT_OBJS := $(BUILD_DIR)/crt.o
SRCS := $(wildcard src/*.rs)
TARGET_OBJ := target/$(TARGET_ARCH_RUST)/$(BUILD_MODE)/librust_basemetal_gba.a

LDFLAGS := --gc-sections --library-path=target/$(TARGET_ARCH_RUST)/$(BUILD_MODE) -lrust_basemetal_gba 

default:
	mkdir -p $(BUILD_DIR)
	make mb

mb: $(BUILD_DIR)/$(BUILD_NAME).mb

$(TARGET_MB): $(TARGET_MB_ELF)
	$(OBJCOPY) -O binary $< $@

$(TARGET_MB_ELF): $(BUILD_DIR)/crt.o mb.ld $(TARGET_OBJ)
	$(LD) -t -T mb.ld -o $@ $(BUILD_DIR)/crt.o $(LDFLAGS) -Map $(BUILD_DIR)/$(BUILD_NAME)_mb.map

$(TARGET_OBJ): $(TARGET_ARCH_RUST).json Cargo.toml $(SRCS)
	RUST_TARGET_PATH=$(PWD) rustup run nightly $(XARGO) build -v --target=$(TARGET_ARCH_RUST)

$(CRT_OBJS): $(BUILD_DIR)/%.o: %.S
	$(AS) $< -o $@

clean:
	rm -rf $(BUILD_DIR)
	xargo clean
