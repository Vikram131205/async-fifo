`timescale 1ns / 1ps
/* This read pointer is reponsible for generating empty condition when the memory module (FIFO) is empty
   this happens when the write pointer is at the same place with the read pointer 
    . To minimize error caused by glitches or 
   timing defects the data shared is gray coded to avoid any miss timings and errors */

module read_ptr_logic#(parameter depth  = 8)(  // 8 levels of depth in FIFO
input rclk, // clock for reading operation
input reset, // reset
output empty,
input r_en, // enable high for reading operation
input [$clog2(depth):0] gray_w_ptr_syn, // gray coded write pointer sent from write pointer to generate the empty condition (synchronised)
output [$clog2(depth):0] bin_w_ptr, // gray coded write pointer converted to binary
 output reg [$clog2(depth):0] bin_r_ptr, 
 output [$clog2(depth):0] gray_r_ptr 
    );
   
    bcd_gray btg(.bin_addr(bin_r_ptr),.gray_addr(gray_r_ptr)); // binary read pointer converted to gray fror sending to the write pointer logic module
    gray_bcd gtb(.gray_addr(gray_w_ptr_syn),.bin_addr(bin_w_ptr)); // gray coded write pointer converted to binary
     assign empty = (bin_r_ptr == bin_w_ptr);
    always @(posedge rclk) begin
    if(reset) begin
    bin_r_ptr <= 0; // reset sets the read and write pointer to starting poistion 0
    end
    else begin
    if(~empty && r_en) begin // read pointer only increments when the fifo is not empty and the read operation is enabled
    bin_r_ptr <= bin_r_ptr + 1;
    end
    end
    end
   
endmodule