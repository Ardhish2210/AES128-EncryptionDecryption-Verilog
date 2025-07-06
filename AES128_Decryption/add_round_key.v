// 4th transformation

module add_round_key (in, key, out4);

input [127:0] in;
input [127:0] key;
output [127:0] out4;

assign out4 = in ^ key;

endmodule
