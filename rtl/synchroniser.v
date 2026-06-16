`timescale 1ns / 1ps

// 2 flip-flop synchroniser to remove metastability 
// includes instantiation of 2 d flip-flops with same clock
module synchroniser#(parameter depth = 8)(
input [$clog2(depth):0]d,
output wire [$clog2(depth):0]q,
input clk
    );
    wire [$clog2(depth):0]w1;
    d_ff uut_1(.clk(clk),.d(d),.q(w1));
    d_ff uut_2(.clk(clk),.d(w1),.q(q));
    
endmodule