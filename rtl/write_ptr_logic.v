`timescale 1ns / 1ps
/* This write pointer is reponsible for generating full condition when the memory module (FIFO) is full
   this happens when the write pointer is at the same place with the read pointer but it has completed one 
   cycle of writing in the module and is back to the same place . To minimize error caused by glitches or 
   timing defects the data shared is gray coded to avoid any miss timings and errors */


module write_ptr_logic#(parameter depth = 8,   // 8 levels of depth in FIFO
parameter d_width = 8)(
input wclk, // clock for writing operation
input reset, // reset
output full, // full flag
input w_en, // enable writing operation (input)

input [$clog2(depth):0] gray_r_ptr_syn, // gray coded read pointer from read pointer logic module (synchronised)
output [$clog2(depth):0] bin_r_ptr, // the read pointer converted to binary system for full flag generation
output reg [$clog2(depth):0] bin_w_ptr, // binary write pointer 
output [$clog2(depth):0] gray_w_ptr // gray coded write pointer to be sent to read pointer module (unsynchronised wrt read clk)
    );
   
    bcd_gray btg(.bin_addr(bin_w_ptr),.gray_addr(gray_w_ptr)); // conversion of binary write pointer to gray for sending it to read module 
    gray_bcd gtb(.gray_addr(gray_r_ptr_syn),.bin_addr(bin_r_ptr)); // conversion of gray code to binary for the recieved synchronised read pointer 
    assign full = ({~bin_w_ptr[$clog2(depth)],bin_w_ptr[$clog2(depth)-1:0]} == bin_r_ptr[$clog2(depth):0]); 
    /* the fifo is full when the write pointer is incremented to such a value when the read and write pointer are at the 
       position in fifo but the write pointer has completed a full cycle of the memory module back to read pointer */
    always @(posedge wclk) begin
    if(reset) begin
    bin_w_ptr <= 0;
     // write operation back to the first level 
    end
    else begin
    if(~full && w_en) // while the write operation control signal is enabled and the fifo is not full the write pointer is incremented
    bin_w_ptr <= bin_w_ptr + 1;
    end
    
    end
    
    
endmodule