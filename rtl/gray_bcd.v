`timescale 1ns / 1ps

// this module converts the synchronised gray to decimal when recieved from the synchroniser
module gray_bcd#(parameter depth = 8)(
input [$clog2(depth):0] gray_addr,
output reg [$clog2(depth):0] bin_addr 
    );
    integer i;
    always @(*) begin
    bin_addr[$clog2(depth)] = gray_addr[$clog2(depth)];
    for( i = ($clog2(depth)-1) ; i >= 0 ; i = i -1 ) begin
    bin_addr[i] = bin_addr[i+1] ^ gray_addr[i];
    end
    end
    
endmodule
// the MSB of the gray and binary decimal remains same 
// (i)th bit of the binary is obtained by XOR'ing the (i+1)th bit of th binary and (i)th bit of gray 