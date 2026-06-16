`timescale 1ns / 1ps

// pseudo dual port memory module , 2 ports , one for write one for read operating on seperate clocks 
module pseudo_dual#(parameter d_width = 32,parameter depth = 8)(  // data width - 32 bits and depth is 8 lines/blocks
input [$clog2(depth):0] bin_w_ptr, // binary write pointer
input [$clog2(depth):0] bin_r_ptr, // binary read pointer
input full,empty, // empty and full flags
input wclk,rclk, // write clock and read clock
input w_en,r_en, // control signals 
input [d_width-1:0] data_in, // input 32 bit data
output reg [d_width-1:0] data_out // output data
    );
    reg [d_width-1:0] mem [0:depth-1]; // memory module
    // writing operation
    always @(posedge wclk) begin
    if(w_en && ~full) 
    mem[bin_w_ptr] <= data_in;
    end
    // reading operation
    always @(posedge rclk) begin
    if(r_en && ~empty)
    data_out <= mem[bin_r_ptr];
    end
endmodule
