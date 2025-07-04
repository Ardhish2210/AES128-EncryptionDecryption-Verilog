`include "key_expansion.v"
`include "encrypt_round.v"
`include "add_round_key.v"
`include "sub_bytes.v"
`include "shift_rows.v"
`include "mix_columns.v"

//`include "aes_sbox.v"
//`include "sub_words.v"

module AES128_encryption (
  input  wire [127:0] plaintext,
  input  wire [127:0] key,
  output wire [127:0] ciphertext
);

  wire [127:0] state[0:10];
  wire [127:0] round_keys[0:10];
  genvar i;

  // Get all round keys
  generate
    for (i = 0; i <= 10; i = i + 1) begin : keys
      key_expansion KE (
        .key(key),
        .round(i[3:0]),
        .round_key(round_keys[i])
      );
    end
  endgenerate

  // Initial AddRoundKey (Round 0)
  assign state[0] = plaintext ^ round_keys[0];

  // Rounds 1 to 9
  generate
    for (i = 1; i < 10; i = i + 1) begin : rounds
      encrypt_round ROUND (
        .in(state[i-1]),
        .key(round_keys[i]),
        .is_final_round(1'b0),
        .out(state[i])
      );
    end
  endgenerate

  // Final Round (10)
  encrypt_round FINAL (
    .in(state[9]),
    .key(round_keys[10]),
    .is_final_round(1'b1),
    .out(ciphertext)
  );

endmodule
