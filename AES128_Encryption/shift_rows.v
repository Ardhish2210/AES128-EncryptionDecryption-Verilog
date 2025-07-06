// 2nd transformation

module shift_rows (in, out2);

    input [127:0] in;
    output [127:0] out2;

    wire [7:0] state_in [15:0];
    wire [7:0] state_out [15:0];

    genvar i;
    generate
        for(i = 0; i < 16; i = i + 1) begin: input_split
            assign state_in[i] = in[127 - i*8 -: 8];
        end
    endgenerate

    // AES ShiftRows transformation
    // Row 0: no shift
    assign state_out[0]  = state_in[0];
    assign state_out[4]  = state_in[4];
    assign state_out[8]  = state_in[8];
    assign state_out[12] = state_in[12];
    
    // Row 1: shift left by 1
    assign state_out[1]  = state_in[5];
    assign state_out[5]  = state_in[9];
    assign state_out[9]  = state_in[13];
    assign state_out[13] = state_in[1];
    
    // Row 2: shift left by 2
    assign state_out[2]  = state_in[10];
    assign state_out[6]  = state_in[14];
    assign state_out[10] = state_in[2];
    assign state_out[14] = state_in[6];
    
    // Row 3: shift left by 3 (or right by 1)
    assign state_out[3]  = state_in[15];
    assign state_out[7]  = state_in[3];
    assign state_out[11] = state_in[7];
    assign state_out[15] = state_in[11];

    // Recombine output
    generate
        for(i = 0; i < 16; i = i + 1) begin: output_combine
            assign out2[127 - i*8 -: 8] = state_out[i];
        end
    endgenerate

endmodule
