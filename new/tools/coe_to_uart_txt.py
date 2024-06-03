import sys
import os

def coe_to_uart_txt(coe_file, width):
    try:
        with open(coe_file, 'r') as coe_f:
            lines = coe_f.readlines()
        
        instructions = []
        start_reading = False
        for line in lines:
            line = line.strip()
            if line.startswith("memory_initialization_vector"):
                start_reading = True
                continue
            if start_reading:
                if line.endswith(';'):
                    line = line[:-1]
                instructions.extend(line.split(','))

        # Remove empty strings
        instructions = [inst.strip() for inst in instructions if inst.strip()]
        
        # Add leading zeros to the instructions to make them 8 characters long
        instructions = [inst.zfill(8) for inst in instructions]

        # Ensure we have exactly 'width' instructions
        if len(instructions) > width:
            instructions = instructions[:width]
        elif len(instructions) < width:
            instructions.extend(['00000000'] * (width - len(instructions)))

        # Generate the header based on width
        header_value = f'{width * 8:08X}'
        header = header_value[0] + '3' + header_value[2:]  # Change the second character to '3'

        # Create the content with the header
        content = [header]
        content.extend(instructions)
        # Ensure the total instructions are width * 2
        content.extend(['00000000'] * (width * 2 - len(instructions)))

        # # Add width * 8 zeros at the end
        # content.extend(['00000000'] * (width))  # Adding width * 8 zeros at the end

        # Automatically create the output TXT file name
        txt_file = os.path.splitext(coe_file)[0] + ".txt"
        
        # Write to the TXT file
        with open(txt_file, 'w') as txt_f:
            for line in content:
                txt_f.write(line)
        
        print(f"Successfully converted {coe_file} to {txt_file}")

    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python coe_to_uart_txt.py <input_file.coe> <width>")
    else:
        coe_file = sys.argv[1]
        try:
            width = int(sys.argv[2])
        except ValueError:
            print("Error: Width must be an integer.")
            sys.exit(1)

        coe_to_uart_txt(coe_file, width)
