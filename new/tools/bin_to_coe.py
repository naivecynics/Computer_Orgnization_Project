import sys

def bin_to_coe(bin_file, coe_file, base):
    try:
        if base == 2:
            radix_str = "memory_initialization_radix=2;\n"
        elif base == 10:
            radix_str = "memory_initialization_radix=10;\n"
        elif base == 16:
            radix_str = "memory_initialization_radix=16;\n"
        else:
            print("Error: Unsupported base. Only 2, 10, and 16 are supported.")
            return

        with open(bin_file, 'rb') as bin_f, open(coe_file, 'w') as coe_f:
            coe_f.write(radix_str)
            coe_f.write("memory_initialization_vector=\n")
            
            data = bin_f.read()
            # 按32位块（4字节）处理数据
            bin_data = [data[i:i+4] for i in range(0, len(data), 4)]
            
            for i, chunk in enumerate(bin_data):
                if base == 2:
                    # 将每个块转换为32位二进制字符串，并确保按大端序处理
                    bin_str = ''.join(f"{byte:08b}" for byte in chunk[::-1])
                elif base == 10:
                    # 将每个块转换为32位十进制字符串，并确保按大端序处理
                    bin_str = str(int.from_bytes(chunk[::-1], byteorder='big'))
                elif base == 16:
                    # 将每个块转换为32位十六进制字符串，并确保按大端序处理
                    bin_str = ''.join(f"{byte:02X}" for byte in chunk[::-1])

                if i != len(bin_data) - 1:
                    coe_f.write(f"{bin_str},\n")
                else:
                    coe_f.write(f"{bin_str};\n")
            
            print(f"Successfully converted {bin_file} to {coe_file} with base {base}")

    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python bin_to_coe.py <input_file.bin> <output_file.coe> <base>")
    else:
        bin_file = sys.argv[1]
        coe_file = sys.argv[2]
        try:
            base = int(sys.argv[3])
        except ValueError:
            print("Error: Base must be an integer.")
            sys.exit(1)

        bin_to_coe(bin_file, coe_file, base)
