// `include "aes_sbox.v"

module sub_word (
    input  [31:0] word_in,
    output [31:0] word_out
);
    wire [7:0] s0, s1, s2, s3;

    aes_sbox u0 (.in(word_in[31:24]), .out(s0));
    aes_sbox u1 (.in(word_in[23:16]), .out(s1));
    aes_sbox u2 (.in(word_in[15:8 ]), .out(s2));
    aes_sbox u3 (.in(word_in[ 7:0 ]), .out(s3));

    assign word_out = {s0, s1, s2, s3};
endmodule
