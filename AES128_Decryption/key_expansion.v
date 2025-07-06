// This module is basically the HEART behind the generation of all the ROUND key

`include "aes_sbox.v"

module key_expansion (
  input  wire [127:0] key,
  input  wire [3:0] round,
  output wire [127:0] round_key
);

  // This function rotates the word by 1 byte ie 8bits towarads left
  function [31:0] rot_word(input [31:0] word);
    rot_word = {word[23:0], word[31:24]};
  endfunction
  
  // "rcon" stands for ROUND CONSTANT (which will be used in later stages), it is predefined for every round
  function [31:0] rcon(input integer r);
    case (r)
      1:  rcon = 32'h01000000;
      2:  rcon = 32'h02000000;
      3:  rcon = 32'h04000000;
      4:  rcon = 32'h08000000;
      5:  rcon = 32'h10000000;
      6:  rcon = 32'h20000000;
      7:  rcon = 32'h40000000;
      8:  rcon = 32'h80000000;
      9:  rcon = 32'h1B000000;
      10: rcon = 32'h36000000;
      default: rcon = 32'h00000000;
    endcase
  endfunction

  wire [31:0] W [0:43];
  wire [127:0] keys [0:10];
  
  // Initial key -> W[0] to W[3]
  assign W[0] = key[127:96];
  assign W[1] = key[95:64];
  assign W[2] = key[63:32];
  assign W[3] = key[31:0];
  
  genvar i;
  generate
    for (i = 4; i < 44; i = i + 1) begin : key_gen
      wire [31:0] temp = W[i-1];

      wire [31:0] rot_out;
      wire [7:0] sb [3:0];

      assign rot_out = rot_word(temp);

      // S-box matching
      aes_sbox sb0 (.in(rot_out[31:24]), .out(sb[3]));
      aes_sbox sb1 (.in(rot_out[23:16]), .out(sb[2]));
      aes_sbox sb2 (.in(rot_out[15:8]),  .out(sb[1]));
      aes_sbox sb3 (.in(rot_out[7:0]),   .out(sb[0]));

      wire [31:0] subword = {sb[3], sb[2], sb[1], sb[0]};

      wire [31:0] temp_xor = (i % 4 == 0) ? (subword ^ rcon(i/4)) : W[i-1];
      assign W[i] = W[i-4] ^ temp_xor;
    end
  endgenerate

  // Combining every 4 words into one 128-bit round key
  generate
    for (i = 0; i < 11; i = i + 1) begin : key_blocks
      assign keys[i] = {W[4*i], W[4*i+1], W[4*i+2], W[4*i+3]};
    end
  endgenerate

  assign round_key = keys[round];

endmodule
