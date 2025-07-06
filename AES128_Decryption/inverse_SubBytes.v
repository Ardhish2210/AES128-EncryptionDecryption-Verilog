// 1st transformation

module inverse_SubBytes (in, out1);

input [127:0] in;
output [127:0] out1;

wire [7:0] inv_sbox_out [15:0];

genvar i;
generate
    for(i=0; i<16; i=i+1) begin
        inverse_sbox uut (.in(in[127 - i*8 -: 8]), .out(inv_sbox_out[i]));
    end
endgenerate

assign out1 = {
        inv_sbox_out[0],  inv_sbox_out[1],  inv_sbox_out[2],  inv_sbox_out[3],
        inv_sbox_out[4],  inv_sbox_out[5],  inv_sbox_out[6],  inv_sbox_out[7],
        inv_sbox_out[8],  inv_sbox_out[9],  inv_sbox_out[10], inv_sbox_out[11],
        inv_sbox_out[12], inv_sbox_out[13], inv_sbox_out[14], inv_sbox_out[15]
    };

endmodule
