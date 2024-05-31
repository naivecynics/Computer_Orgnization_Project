import sys

def bin_to_coe(bin_file, coe_file):
    try:
        with open(bin_file, 'rb') as bin_f, open(coe_file, 'w') as coe_f:
            coe_f.write("memory_initialization_radix=2;\n")
            coe_f.write("memory_initialization_vector=\n")
            
            data = bin_f.read()
            # 按32位块（4字节）处理数据
            bin_data = [data[i:i+4] for i in range(0, len(data), 4)]
            
            for i, chunk in enumerate(bin_data):
                # 将每个块转换为32位二进制字符串，并确保按大端序处理
                bin_str = ''.join(f"{byte:08b}" for byte in chunk[::-1])
                if i != len(bin_data) - 1:
                    coe_f.write(f"{bin_str},\n")
                else:
                    coe_f.write(f"{bin_str};\n")
            
            print(f"Successfully converted {bin_file} to {coe_file}")

    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python bin_to_coe.py <input_file.bin> <output_file.coe>")
    else:
        bin_to_coe(sys.argv[1], sys.argv[2])
