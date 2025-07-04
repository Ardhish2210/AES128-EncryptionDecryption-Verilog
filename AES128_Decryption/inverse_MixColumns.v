module inverse_MixColumns (
    input  [127:0] in,
    output [127:0] out
);

    wire [7:0] s [0:15];
    wire [7:0] mix_out [0:15];

    // === Correct Column-Major Mapping (Input) ===
    assign s[ 0] = in[127:120]; // col 0, row 0
    assign s[ 4] = in[119:112];
    assign s[ 8] = in[111:104];
    assign s[12] = in[103:96];

    assign s[ 1] = in[95:88];   // col 1, row 0
    assign s[ 5] = in[87:80];
    assign s[ 9] = in[79:72];
    assign s[13] = in[71:64];

    assign s[ 2] = in[63:56];   // col 2, row 0
    assign s[ 6] = in[55:48];
    assign s[10] = in[47:40];
    assign s[14] = in[39:32];

    assign s[ 3] = in[31:24];   // col 3, row 0
    assign s[ 7] = in[23:16];
    assign s[11] = in[15:8];
    assign s[15] = in[7:0];

    // === Inverse MixColumns Transformation ===
    genvar c;
    generate
        for (c = 0; c < 4; c = c + 1) begin : column_inv_mix
            assign mix_out[c     ] = gmul_e(s[c])     ^ gmul_b(s[c+4]) ^ gmul_d(s[c+8]) ^ gmul_9(s[c+12]);
            assign mix_out[c+4  ] = gmul_9(s[c])     ^ gmul_e(s[c+4]) ^ gmul_b(s[c+8]) ^ gmul_d(s[c+12]);
            assign mix_out[c+8  ] = gmul_d(s[c])     ^ gmul_9(s[c+4]) ^ gmul_e(s[c+8]) ^ gmul_b(s[c+12]);
            assign mix_out[c+12 ] = gmul_b(s[c])     ^ gmul_d(s[c+4]) ^ gmul_9(s[c+8]) ^ gmul_e(s[c+12]);
        end
    endgenerate

    // === Correct Column-Major Mapping (Output) ===
    assign out[127:120] = mix_out[ 0];
    assign out[119:112] = mix_out[ 4];
    assign out[111:104] = mix_out[ 8];
    assign out[103:96]  = mix_out[12];

    assign out[95:88]   = mix_out[ 1];
    assign out[87:80]   = mix_out[ 5];
    assign out[79:72]   = mix_out[ 9];
    assign out[71:64]   = mix_out[13];

    assign out[63:56]   = mix_out[ 2];
    assign out[55:48]   = mix_out[ 6];
    assign out[47:40]   = mix_out[10];
    assign out[39:32]   = mix_out[14];

    assign out[31:24]   = mix_out[ 3];
    assign out[23:16]   = mix_out[ 7];
    assign out[15:8]    = mix_out[11];
    assign out[7:0]     = mix_out[15];

    // === GF(2^8) Multiplication Functions ===
    function [7:0] gmul_2(input [7:0] b);
        gmul_2 = (b[7]) ? ((b << 1) ^ 8'h1b) : (b << 1);
    endfunction

    function [7:0] gmul_3(input [7:0] b);
        gmul_3 = gmul_2(b) ^ b;
    endfunction

    function [7:0] gmul_9(input [7:0] b);
        gmul_9 = gmul_2(gmul_2(gmul_2(b))) ^ b;
    endfunction

    function [7:0] gmul_b(input [7:0] b);
        gmul_b = gmul_2(gmul_2(gmul_2(b))) ^ gmul_2(b) ^ b;
    endfunction

    function [7:0] gmul_d(input [7:0] b);
        gmul_d = gmul_2(gmul_2(gmul_2(b))) ^ gmul_2(gmul_2(b)) ^ b;
    endfunction

    function [7:0] gmul_e(input [7:0] b);
        gmul_e = gmul_2(gmul_2(gmul_2(b))) ^ gmul_2(gmul_2(b)) ^ gmul_2(b);
    endfunction

endmodule
