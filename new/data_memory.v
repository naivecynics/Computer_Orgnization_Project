module data_memory(
    input clk,     //from top
    input MemWrite,  //from controller
    input [13:0] ALUResult,  //from ALU
    input [31:0] R_data2,  //from reg_file
    output [31:0] ram_data_out  //the data read from ram 
);

wire ram_clk = !clk;

prgram data_memory (
    .clka(ram_clk),
    .addra(ALUResult),
    .dina(R_data2),
    .douta(ram_data_out),
    .wea(MemWrite)
);


endmodule
