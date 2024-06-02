module data_memory(
    // Normal RAM Pin
    input clk,                  //from top
    input MemWrite,             //from controller
    input [13:0] ALUResult,     //from ALU
    input [31:0] R_data2,       //from reg_file
    output [31:0] ram_data_out,  //the data read from ram 

    // UART Developer Pin
    input         upg_rst_i,    // reset (active high)
    input         upg_clk_i,    // clock (10MHz)
    input         upg_wen_i,
    input [13:0]  upg_adr_i,
    input [31:0]  upg_dat_i,
    input         upg_done_i    // 1: done, 0: busy
);

    wire ram_clk = !clk;
    wire kickOff = upg_rst_i | (!upg_rst_i & upg_done_i);

    // prgram data_memory (
    //     .clka(ram_clk),
    //     .addra(ALUResult),
    //     .dina(R_data2),
    //     .douta(ram_data_out),
    //     .wea(MemWrite)
    // );

    prgram data_memory (
        .clka(kickOff ? ram_clk : upg_clk_i),
        .addra(kickOff ? ALUResult : upg_adr_i),
        .dina(kickOff ? R_data2 : upg_dat_i),
        .douta(ram_data_out),
        .wea(kickOff ? MemWrite : upg_wen_i)
    );


endmodule
