// `include "aes_sbox.v"

// 1st Transformation
module sub_bytes (out1, in);

input [127:0] in;
output [127:0] out1;

wire [7:0] sbox_out [15:0];

genvar i;
generate
    for (i=0; i<16; i=i+1) begin: sbox_loop
        aes_sbox SubBytes (.in(in[127 - i*8 -: 8]), .out(sbox_out[i]));
    end
endgenerate

assign out1 = {
        sbox_out[0],  sbox_out[1],  sbox_out[2],  sbox_out[3],
        sbox_out[4],  sbox_out[5],  sbox_out[6],  sbox_out[7],
        sbox_out[8],  sbox_out[9],  sbox_out[10], sbox_out[11],
        sbox_out[12], sbox_out[13], sbox_out[14], sbox_out[15]
    };

endmodule
