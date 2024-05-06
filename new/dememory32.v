module dememory32(
    input         ram_clk_i,    // from cpu_top
    input         ram_wen_i,    // from controller (write enable)
    input  [13:0] ram_adr_i,    // from alu (address)
    input  [31:0] ram_dat_i,    // 
    output [31:0] ram_dat_o,    //

    // UART Developer Pin
    input         upg_rst_i,    // reset (active high)
    input         upg_clk_i,    // clock (10MHz)
    input         upg_wen_i,
    input [13:0]  upg_adr_i,
    input [31:0]  upg_dat_i,
    input         upg_done_i
);



endmodule