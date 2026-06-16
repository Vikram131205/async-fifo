`timescale 1ns / 1ps


module asy_FIFO#(parameter depth = 8 , parameter d_width = 32)(
input [d_width-1:0] data_in,
input w_en,r_en,
input wclk,rclk,
output wire [$clog2(depth):0] bin_w_ptr,bin_r_ptr,
output full,empty,
output wire [d_width-1:0] data_out,
input reset
    );
    top_module uut(.wclk(wclk),
                   .rclk(rclk),
                   .reset(reset),
                   .w_en(w_en),
                   .r_en(r_en),
                   .bin_w_ptr(bin_w_ptr),
                   .bin_r_ptr(bin_r_ptr),
                   .full(full),
                   .empty(empty));
    pseudo_dual uut1( .wclk(wclk),
                      .rclk(rclk),              
                      .w_en(w_en),
                      .r_en(r_en),
                      .bin_w_ptr(bin_w_ptr),
                      .bin_r_ptr(bin_r_ptr),
                      .full(full),
                      .empty(empty),
                      .data_in(data_in),
                      .data_out(data_out));
endmodule