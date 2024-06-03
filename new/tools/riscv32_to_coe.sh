#!/bin/bash

# argument checking
if [ $# -lt 2 ]; then
    echo "Usage: $0 <file.asm> <coe_base>"
    exit 1
fi

input_file="$1"
coe_base="$2"
base_name="${input_file%.*}"

# assembling
riscv32-unknown-elf-as "$input_file" -o "${base_name}.o" -march=rv32i
if [ $? -ne 0 ]; then
    echo "Assembly failed."
    exit 1
else
    echo "Assembly Successfully."
fi

# linking
riscv32-unknown-elf-ld "${base_name}.o" -o "${base_name}.om"
if [ $? -ne 0 ]; then
    echo "Linking failed."
    exit 1
else
    echo "Linking Successfully."
fi

# binary
riscv32-unknown-elf-objcopy -O binary "${base_name}.om" "${base_name}.bin"
if [ $? -ne 0 ]; then
    echo "Objcopy failed."
    exit 1
else
    echo "Objcopy Successfully."
fi

# binary to coe
python3 bin_to_coe.py "${base_name}.bin" "${base_name}.coe" "$coe_base"
if [ $? -ne 0 ]; then
    echo "Conversion to COE failed."
    exit 1
else
    echo "Binary to coe Successfully."
fi

# remove internal files
rm -f "${base_name}.o" "${base_name}.om" "${base_name}.bin"

echo "Build successful: ${base_name}.coe"
