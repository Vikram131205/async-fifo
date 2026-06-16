`timescale 1ns / 1ps
// top_module is repsonsible for connections between the different modules and their proper instantiations 
module top_module#(parameter depth = 8 )(
input rclk, // read clock
input wclk, // write clock
input reset, // universal reset
input w_en,r_en, // control signals from user 
output [$clog2(depth):0] bin_w_ptr,bin_r_ptr,
    output [$clog2(depth):0] gray_w_ptr,gray_w_ptr_syn,
    output [$clog2(depth):0] gray_r_ptr,gray_r_ptr_syn,
    output full,empty
    );
    // write pointer logic recieves control signal from the user , generates a binary write pointer passes to the read pointer (gray coded and synchronised)
    write_ptr_logic wl(.wclk(wclk),.reset(reset),.full(full),.gray_w_ptr(gray_w_ptr),.gray_r_ptr_syn(gray_r_ptr_syn),.w_en(w_en),.bin_w_ptr(bin_w_ptr));
    // read pointer logic recieves control signal from the user , generates a binary read pointer passes to the write pointer module  (gray coded and synchronised)
    read_ptr_logic rl(.rclk(rclk),.reset(reset),.empty(empty),.gray_r_ptr(gray_r_ptr),.gray_w_ptr_syn(gray_w_ptr_syn),.r_en(r_en),.bin_r_ptr(bin_r_ptr));
    // 2 flip-flop synchroniser to remove metastability 
    synchroniser write(.clk(rclk),.d(gray_w_ptr),.q(gray_w_ptr_syn));
    synchroniser read(.clk(wclk),.d(gray_r_ptr),.q(gray_r_ptr_syn));
    
endmodule