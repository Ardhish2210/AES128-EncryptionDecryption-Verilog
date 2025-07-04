//`include "sub_bytes.v"
//`include "shift_rows.v" 
//`include "mix_columns.v"
//`include "add_round_key.v"
//`include "aes_sbox.v"

// AES Encryption Round
// Applies SubBytes → ShiftRows → (MixColumns*) → AddRoundKey
// Skips MixColumns in the final round

module encrypt_round (
  input  [127:0] in,
  input  [127:0] key,
  input          is_final_round,
  output [127:0] out
);

  wire [127:0] subbytes_out;
  wire [127:0] shiftrows_out;
  wire [127:0] mixcolumns_out;

  // SubBytes stage
  sub_bytes SB (
    .in(in),
    .out1(subbytes_out)
  );

  // ShiftRows stage
  shift_rows SR (
    .in(subbytes_out),
    .out2(shiftrows_out)
  );

  // MixColumns stage (only used if not final round)
  mix_columns MC (
    .in(shiftrows_out),
    .out3(mixcolumns_out)
  );

  // Final round logic:
  // If final round, skip MixColumns and apply AddRoundKey directly
  // Otherwise, AddRoundKey comes after MixColumns
  assign out = is_final_round ? (shiftrows_out ^ key) : (mixcolumns_out ^ key);

endmodule
