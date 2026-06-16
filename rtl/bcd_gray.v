`timescale 1ns / 1ps
/* this module is used to convert binary coded decimal to gray coded decimal */
/* this gray code is further send to the other pointer logic for empty and full flag generation*/
module bcd_gray#(parameter depth = 8)( 
input [$clog2(depth):0] bin_addr, // recieved binary coded decimal
output reg [$clog2(depth):0] gray_addr // gray coded decimal
    );
    integer i;
    always @(*) begin
    gray_addr[$clog2(depth)] = bin_addr[$clog2(depth)];
    for(i = ($clog2(depth)-1) ; i >= 0 ; i = i -1 )begin
    gray_addr[i] = bin_addr[i+1] ^ bin_addr[i];
    end
    
    end
endmodule
// logic - MSB remains same , other digits are obtained by XOR'ing the bits in the (i+1)th and (i)th position 
// to obtain the (i)th gray bit.