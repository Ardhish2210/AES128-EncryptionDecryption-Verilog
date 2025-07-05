`timescale 1ns / 1ps
`include "AES128_encryption.v"

module AES128_encryption_tb;

  reg  [127:0] plaintext;
  reg  [127:0] key;
  wire [127:0] ciphertext;

  AES128_encryption dut (.plaintext(plaintext), .key(key), .ciphertext(ciphertext));
  
  initial begin
    $display("Starting AES-128 Encryption Test Vectors...\n");

    // Test 1
    key       = 128'h2b7e151628aed2a6abf7158809cf4f3c;
    plaintext = 128'h6bc1bee22e409f96e93d7e117393172a;
    #10;
    $display("Test 1\n  Key       : %h\n  Plaintext : %h\n  Ciphertext: %h", key, plaintext, ciphertext);
    if (ciphertext === 128'h3ad77bb40d7a3660a89ecaf32466ef97) $display("Pass\n");
    else $display("Fail\n");


    // Test 2
    key       = 128'h000102030405060708090a0b0c0d0e0f;
    plaintext = 128'h00112233445566778899aabbccddeeff;
    #10;
    $display("Test 2\n  Key       : %h\n  Plaintext : %h\n  Ciphertext: %h", key, plaintext, ciphertext);
    if (ciphertext === 128'h69c4e0d86a7b0430d8cdb78070b4c55a) $display("Pass\n");
    else $display("Fail\n");

    $finish;
  end

endmodule
