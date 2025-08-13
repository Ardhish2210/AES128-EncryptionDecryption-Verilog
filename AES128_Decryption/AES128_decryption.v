`include "key_expansion.v"
`include "decrypt_round.v"
`include "add_round_key.v"
`include "inverse_SubBytes.v"
`include "inverse_ShiftRows.v"
`include "inverse_MixColumns.v"
`include "inverse_sbox.v"

// Performs 10 rounds: Initial AddRoundKey + 9 decrypt_rounds + Final decrypt_round (no InverseMixColumns)

module AES128_decryption (input  wire [127:0] ciphertext, input  wire [127:0] key, output wire [127:0] plaintext);

  wire [127:0] state[0:10];
  wire [127:0] round_keys[0:10];
  genvar i;

  generate
    for (i = 0; i <= 10; i = i + 1) begin : key_schedule
      key_expansion KE (
        .key(key),
        .round(i[3:0]),
        .round_key(round_keys[i])
      );
    end
  endgenerate

  assign state[0] = ciphertext ^ round_keys[10];

  generate
    for (i = 1; i < 10; i = i + 1) begin : decrypt_rounds
      decrypt_round DR (
        .in(state[i-1]),
        .key(round_keys[10 - i]),
        .is_final_round(1'b0),
        .out(state[i])
      );
    end
  endgenerate

  decrypt_round FINAL (
    .in(state[9]),
    .key(round_keys[0]),
    .is_final_round(1'b1),
    .out(plaintext)
  );

endmodule
