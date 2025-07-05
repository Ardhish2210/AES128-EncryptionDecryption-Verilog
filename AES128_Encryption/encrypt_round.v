//This module will help in carrying out all the 4 transformation for each round
// Round (1 to 9) -> All 4 transformation will be applied
// Round 10 -> All the transformation will be applied, except the "MIX COLUMNS".

module encrypt_round (
  input  [127:0] in,
  input  [127:0] key,
  input          is_final_round,
  output [127:0] out
);

  wire [127:0] subbytes_out;
  wire [127:0] shiftrows_out;
  wire [127:0] mixcolumns_out;

  sub_bytes SB (.in(in), .out1(subbytes_out));
  shift_rows SR (.in(subbytes_out), .out2(shiftrows_out));
  mix_columns MC (.in(shiftrows_out), .out3(mixcolumns_out));

  // If the "is_final_round" = 1, then the MIX COLUMN transformation will be avoided
  // The operation performed below is the ADD ROUND KEY transformation
  
  assign out = is_final_round ? (shiftrows_out ^ key) : (mixcolumns_out ^ key);

endmodule
