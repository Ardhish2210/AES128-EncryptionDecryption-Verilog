`include "key_expansion.v"
`include "encrypt_round.v"
`include "add_round_key.v"
`include "sub_bytes.v"
`include "shift_rows.v"
`include "mix_columns.v"

module AES128_encryption (
  input  wire [127:0] plaintext,
  input  wire [127:0] key,
  output wire [127:0] ciphertext
);

  wire [127:0] state[0:10];
  wire [127:0] round_keys[0:10];
  genvar i;


  // The below loop will help us fetch all the round keys
  generate
    for (i = 0; i <= 10; i = i + 1) begin : keys
      key_expansion KE (.key(key), .round(i[3:0]), .round_key(round_keys[i]));
    end
  endgenerate

  // This is the key used for INITIAL TRANSFORMSTION
  assign state[0] = plaintext ^ round_keys[0];

  // Transformation's from ROUND-1 to ROUND-9
  generate
    for (i = 1; i < 10; i = i + 1) begin : rounds
      encrypt_round ROUND (.in(state[i-1]), .key(round_keys[i]), .is_final_round(1'b0), .out(state[i]));
    end
  endgenerate

  // ROUND-10 (Final) Transformation
  encrypt_round FINAL (.in(state[9]), .key(round_keys[10]), .is_final_round(1'b1), .out(ciphertext));
endmodule
