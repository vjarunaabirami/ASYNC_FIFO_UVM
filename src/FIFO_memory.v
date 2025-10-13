//----------------DESCRIPTION-----------------
// This code is for a synchronous FIFO memory module
// with configurable data size and address size.
// It uses a dual-port memory structure.
//---------------------------------------------

module FIFO_memory #(
    parameter DATA_SIZE = 8,
    parameter ADDR_SIZE = 4
)(
    output reg [DATA_SIZE-1:0] rdata,       // Registered read data
    input  [DATA_SIZE-1:0] wdata,           // Data to be written
    input  [ADDR_SIZE-1:0] waddr, raddr,    // Write and read addresses
    input  wclk_en,                         // Write clock enable
    input  wfull,                           // Write full flag
    input  wclk,
	input rclk                             // Write clock
);

    localparam DEPTH = 1 << ADDR_SIZE;      // FIFO depth
    reg [DATA_SIZE-1:0] mem [0:DEPTH-1];    // Memory array

    // Write operation
    always @(posedge wclk)
        if (wclk_en && !wfull)
            mem[waddr] <= wdata;

    // Read operation (synchronous read)
  always @(posedge rclk)
		
        rdata <= mem[raddr];

endmodule

