module dememory32(
    // Normal RAM Pin
    input         ram_clk_i,    // from cpu_top
    input         ram_wen_i,    // from controller (write enable)
    input  [13:0] ram_adr_i,    // from alu (address)
    input  [31:0] ram_dat_i,   

    output [31:0] ram_dat_o,    

    // UART Developer Pin
    input         upg_rst_i,    // reset (active high)
    input         upg_clk_i,    // clock (10MHz)
    input         upg_wen_i,
    input [13:0]  upg_adr_i,
    input [31:0]  upg_dat_i,
    input         upg_done_i    // 1: done, 0: busy
);

    // ? in slide, i don't know why
    wire ram_clk = ~ram_clk_i;

    // 1 : normal mode
    // 0 : program mode
    wire kickoff = upg_rst_i | (~upg_wen_i & upg_done_i);

    // prgram data_memory (
    //     .clka  (~kickoff ? upg_clk_i : ram_clk),
    //     .addra (~kickoff ? upg_adr_i : ram_adr_i),
    //     .dina  (~kickoff ? upg_dat_i : ram_dat_i),
    //     .douta (~kickoff ? upg_dat_i : ram_dat_o),
    //     .wea   (~kickoff ? upg_wen_i : ram_wen_i)
    // );

    prgram data_memory (
        .clka  (ram_clk),
        .addra (ram_adr_i),
        .dina  (ram_dat_i),
        .douta (ram_dat_o),
        .wea   (ram_wen_i)
    );

endmodule