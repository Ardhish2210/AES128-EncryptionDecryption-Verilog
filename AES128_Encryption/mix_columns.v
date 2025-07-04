module mix_columns (
    input  [127:0] in,
    output [127:0] out3
);

    wire [7:0] s [0:15];
    wire [7:0] mix_out [0:15];

    // === Correct Column-Major Mapping (Input) ===
    assign s[ 0] = in[127:120]; // col 0, row 0
    assign s[ 4] = in[119:112]; // col 0, row 1
    assign s[ 8] = in[111:104]; // col 0, row 2
    assign s[12] = in[103:96];  // col 0, row 3

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

    // === MixColumns Transformation ===
    genvar c;
    generate
        for (c = 0; c < 4; c = c + 1) begin : column_mix
            assign mix_out[c     ] = gmul2(s[c])     ^ gmul3(s[c+4]) ^ s[c+8]     ^ s[c+12];
            assign mix_out[c+4  ] = s[c]             ^ gmul2(s[c+4]) ^ gmul3(s[c+8]) ^ s[c+12];
            assign mix_out[c+8  ] = s[c]             ^ s[c+4]       ^ gmul2(s[c+8]) ^ gmul3(s[c+12]);
            assign mix_out[c+12 ] = gmul3(s[c])     ^ s[c+4]       ^ s[c+8]       ^ gmul2(s[c+12]);
        end
    endgenerate

    // === Correct Column-Major Mapping (Output) ===
    assign out3[127:120] = mix_out[ 0];
    assign out3[119:112] = mix_out[ 4];
    assign out3[111:104] = mix_out[ 8];
    assign out3[103:96]  = mix_out[12];

    assign out3[95:88]   = mix_out[ 1];
    assign out3[87:80]   = mix_out[ 5];
    assign out3[79:72]   = mix_out[ 9];
    assign out3[71:64]   = mix_out[13];

    assign out3[63:56]   = mix_out[ 2];
    assign out3[55:48]   = mix_out[ 6];
    assign out3[47:40]   = mix_out[10];
    assign out3[39:32]   = mix_out[14];

    assign out3[31:24]   = mix_out[ 3];
    assign out3[23:16]   = mix_out[ 7];
    assign out3[15:8]    = mix_out[11];
    assign out3[7:0]     = mix_out[15];

    // === GF(2^8) multiply by 2 ===
    function [7:0] gmul2;
        input [7:0] b;
        begin
            gmul2 = (b[7]) ? ((b << 1) ^ 8'h1b) : (b << 1);
        end
    endfunction

    // === GF(2^8) multiply by 3 ===
    function [7:0] gmul3;
        input [7:0] b;
        begin
            gmul3 = gmul2(b) ^ b;
        end
    endfunction

endmodule