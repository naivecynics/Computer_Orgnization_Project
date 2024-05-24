def binary_to_coe(input_file, output_file):
    with open(input_file, 'r') as infile:
        binary_lines = infile.readlines()

    # 创建 COE 文件的头部
    coe_header = "memory_initialization_radix=2;\nmemory_initialization_vector=\n"
    coe_body = ""

    # 遍历每一行二进制数
    for line in binary_lines:
        # 去除行尾的换行符
        binary_number = line.strip()
        # 添加逗号和换行符，除最后一行外
        coe_body += binary_number + ",\n"

    # 去除最后一个二进制数的逗号，并添加结束符号
    coe_body = coe_body.rstrip(",\n") + ";\n"

    # 将头部和内容合并
    coe_content = coe_header + coe_body

    # 将内容写入 COE 文件
    with open(output_file, 'w') as outfile:
        outfile.write(coe_content)

# 调用函数，将test.txt转换为output.coe
binary_to_coe('/mnt/c/SUSCode/CS202_Computer-Organization/project/project/project.srcs/new/assemble/hlc_test_board.txt', '/mnt/c/SUSCode/CS202_Computer-Organization/project/project/project.srcs/new/assemble/hlc_test_board.coe')
