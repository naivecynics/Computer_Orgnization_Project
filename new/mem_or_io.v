module mem_or_io(
   input mRead,    //read memory from Controller
   input mWrite,   //write memory from Controller
   input ioRead,   //read io from Controller
   input ioWrite,  //write io from Controller

   input [31:0] addr_in,  //from alu_result in ALU
   output [31:0] addr_out, //address to DataMemory

   input [31:0] m_rdata,  //data read from DataMemory
   input [15:0] io_rdata,  //data read from IO, 16-bit
   output [31:0] r_wdata,  //data to Decoder(register file)

   input [31:0] r_rdata,  //data read from Decoder(register file)
   output reg [31:0] write_data, //data to memory or I/O (m_wdata or io_wdata)

   output LEDCtrl, //LED Chip Select
   output SwitchCtrl  // Switch Chip Select
);

assign addr_out = addr_in;
// The data wirte to register file may be from memory or io. 
// While the data is from io, it should be the lower 16bit of r_wdata.

// assign r_wdata = ????

// Chip select signal of  Led and Switch  are all active high;
// assign LEDCtrl=  ??? 
// assign SwitchCtrl= ???

always @(*) begin
    if ((mWrite == 1) || (ioWrite == 1)) begin
        //write_data could go to either memory or IO. Where is it from ?
        // write_data = ????
    end
    else begin
        write_data = 32'hzzzzzzzz; 
    end
end

endmodule