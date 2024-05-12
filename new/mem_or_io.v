module mem_or_io(
    //  form controler
    input r_mem_en,   
    input w_mem_en,
    input r_io_en,
    input w_io_en,
    
    // address passby
    input  [31:0] adr_in,
    output [31:0] adr_out,

    // data read
    input  [31:0] r_mem_dat,    // from memory
    input  [31:0] r_reg_dat,    // from register file
    input  [15:0] r_io_dat,     // from 16 switches
    // maybe later add more input (buttons, keyboard, etc)

    // data write
    output [31:0] w_reg_dat     // write back to register file
    output reg [31:0] w_mem_or_oi_dat,
    output led_ctrl,
    output sw_ctrl
)

    assign adr_out = adr_in;

endmodule