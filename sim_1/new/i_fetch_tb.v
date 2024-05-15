`timescale 1ns / 1ps

module testbench();

    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in ns
    
    // Signals
    reg clk = 0;
    reg rst_n = 0;
    reg [31:0] instruction = 32'h00000000;
    reg [31:0] addr_result;
    reg [31:0] read_data_1;
    reg branch = 0; 
    reg n_branch = 0;
    reg jmp = 0;
    reg jal = 0;
    reg jr = 0;
    reg zero;
    wire [31:0] pc_plus_4;
    wire [31:0] pc;
    
    // Instantiate the i_fetch module
    i_fetch i_fetch_inst (
        .clk(clk),
        .rst_n(rst_n),
        .instruction(instruction),
        .addr_result(addr_result),
        .read_data_1(read_data_1),
        .branch(branch),
        .n_branch(n_branch),
        .jmp(jmp),
        .jal(jal),
        .jr(jr),
        .zero(zero),
        .pc_plus_4(pc_plus_4),
        .pc(pc)
    );
    
    // Clock generation
    always #((CLK_PERIOD / 2)) clk = ~clk;
    
    // Reset generation
    initial begin
        #20 rst_n = 1; // Deassert reset after 20 ns
        #10000 $finish; // End simulation after 100 ns
    end
    
    // Test cases
    initial begin
        // Test BEQ instruction
        #10 instruction = 32'h012A0000; // BEQ instruction, rs1 = x5, rs2 = x10, offset = 0
        #20 branch = 1;
        #20 zero = 1;
        #30 addr_result = 32'h0000018; // Jump to address 8
        // Verify pc_plus_4 after beq
        $display("PC + 4 after BEQ: %h", pc_plus_4);
        
        // Test BNE instruction
        #10 instruction = 32'h012A0000; // BNE instruction, rs1 = x5, rs2 = x10, offset = 0
        #20 n_branch = 1;
        #20 zero = 0;
        #30 addr_result = 32'h00000008; // Jump to address 8
        // Verify pc_plus_4 after bne
        $display("PC + 4 after BNE: %h", pc_plus_4);
        
        // Test JMP instruction
        #10 instruction = 32'h6E000000; // JMP instruction, target = 0x00000000
        #20 jmp = 1;
        // Verify pc_plus_4 after jmp
        $display("PC + 4 after JMP: %h", pc_plus_4);
        
        // Test JAL instruction
        #10 instruction = 32'hFF5F0000; // JAL instruction, rd = x31, offset = 0
        #20 jal = 1;
        // Verify pc_plus_4 after jal
        $display("PC + 4 after JAL: %h", pc_plus_4);
        
        // Test JR instruction
        #10 instruction = 32'h00000000; // JR instruction, rs1 = x0, rs2 = x0, offset = 0
        #20 jr = 1;
        #30 read_data_1 = 32'h00000010; // Read data from register x16
        // Verify pc_plus_4 after jr
        $display("PC + 4 after JR: %h", pc_plus_4);
        
    end
    
endmodule
