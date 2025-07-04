`timescale 1ns / 1ps
`include "AES128_decryption.v"

module AES128_decryption_tb;

  reg  [127:0] ciphertext;
  reg  [127:0] key;
  wire [127:0] decrypted_plaintext;

  AES128_decryption dut (
    .ciphertext(ciphertext),
    .key(key),
    .plaintext(decrypted_plaintext)
  );

  initial begin
    $dumpfile("decryption.vcd");
    $dumpvars();
    
    $display("Starting AES-128 Decryption Test Vectors...\n");

    // Test 1
    key        = 128'h2b7e151628aed2a6abf7158809cf4f3c;
    ciphertext = 128'h3ad77bb40d7a3660a89ecaf32466ef97;
    #10;
    $display("Test 1\n  Key        : %h\n  Ciphertext : %h\n  Plaintext  : %h", key, ciphertext, decrypted_plaintext);
    if (decrypted_plaintext === 128'h6bc1bee22e409f96e93d7e117393172a) $display("Pass\n");
    else $display("Fail\n");


    // Test 2
    key        = 128'h000102030405060708090a0b0c0d0e0f;
    ciphertext = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;
    #10;
    $display("Test 2\n  Key        : %h\n  Ciphertext : %h\n  Plaintext  : %h", key, ciphertext, decrypted_plaintext);
    if (decrypted_plaintext === 128'h00112233445566778899aabbccddeeff) $display("Pass\n");
    else $display("Fail\n");

    $finish;
  end

endmodule
