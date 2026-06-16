`timescale 1ns / 1ps


// basic positive edge triggeered D flip - flop w/o reset
module d_ff#(parameter depth = 8)(
input clk,
input [$clog2(depth):0]d,
output reg [$clog2(depth):0]q
    );
    always @(posedge clk) begin
    q <= d;
    end
endmodule