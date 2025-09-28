//`include "inv_shift_rows.v"
//`include "inv_sub_bytes.v"
//`include "inv_mix_columns.v"
//`include "add_round_key.v"
//`include "aes_inv_sbox.v"
// AES Decryption Round
// Applies InvShiftRows → InvSubBytes → AddRoundKey → (InvMixColumns*)
// Skips InvMixColumns in the final round

module decrypt_round (
  input  [127:0] in,
  input  [127:0] key,
  input  is_final_round,
  output [127:0] out
);

  wire [127:0] shiftrows_out;
  wire [127:0] subbytes_out;
  wire [127:0] addroundkey_out;
  wire [127:0] invmix_out;

  inverse_ShiftRows ISR (.in(in), .out2(shiftrows_out));
  inverse_SubBytes ISB (.in(shiftrows_out), .out1(subbytes_out));

  assign addroundkey_out = subbytes_out ^ key;
  
  inverse_MixColumns IMC (.in(addroundkey_out), .out(invmix_out));
  
  assign out = is_final_round ? addroundkey_out : invmix_out;

endmodule
