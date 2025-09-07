
// Ones Counter
// Receives a 32-bit thermometer code and outputs its binary equivalent
module ones_counter_5bit(
  input wire [31:0] data_in,
  output  [4:0] data_out);
    
  wire [4:0]d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10, d11,d12,d13,d14,d15,d16,d17,d18,d19,d20,d21, d22,d23,d24,d25,d26,d27,d28,d29,d30,d31 ;
  
  // Copy each bit in 32-bit data to 5-bit bus
  assign d0 = {1'b0,1'b0,1'b0, 1'b0,data_in[0]};
  assign d1 = {1'b0,1'b0,1'b0, 1'b0,data_in[1]};
  assign d2 = {1'b0,1'b0,1'b0, 1'b0,data_in[2]};
  assign d3 = {1'b0,1'b0,1'b0, 1'b0, data_in[3]};
  assign d4 = {1'b0,1'b0,1'b0, 1'b0, data_in[4]};
  assign d5 = {1'b0,1'b0,1'b0, 1'b0, data_in[5]};
  assign d6 = {1'b0,1'b0,1'b0, 1'b0, data_in[6]};
  assign d7 = {1'b0,1'b0,1'b0, 1'b0, data_in[7]};
  assign d8 = {1'b0,1'b0,1'b0, 1'b0,data_in[8]};
  assign d9 = {1'b0,1'b0,1'b0, 1'b0,data_in[9]};
  assign d10 = {1'b0,1'b0,1'b0, 1'b0,data_in[10]};
  assign d11 = {1'b0,1'b0,1'b0, 1'b0, data_in[11]};
  assign d12 = {1'b0,1'b0,1'b0, 1'b0, data_in[12]};
  assign d13 = {1'b0,1'b0,1'b0, 1'b0, data_in[13]};
  assign d14 = {1'b0,1'b0,1'b0, 1'b0, data_in[14]};
  assign d15 = {1'b0,1'b0,1'b0, 1'b0, data_in[15]};
  assign d16 = {1'b0,1'b0,1'b0, 1'b0,data_in[16]};
  assign d17 = {1'b0,1'b0,1'b0, 1'b0,data_in[17]};
  assign d18 = {1'b0,1'b0,1'b0, 1'b0,data_in[18]};
  assign d19 = {1'b0,1'b0,1'b0, 1'b0, data_in[19]};
  assign d20 = {1'b0,1'b0,1'b0, 1'b0, data_in[20]};
  assign d21 = {1'b0,1'b0,1'b0, 1'b0, data_in[21]};
  assign d22 = {1'b0,1'b0,1'b0, 1'b0, data_in[22]};
  assign d23 = {1'b0,1'b0,1'b0, 1'b0, data_in[23]};
  assign d24 = {1'b0,1'b0,1'b0, 1'b0,data_in[24]};
  assign d25 = {1'b0,1'b0,1'b0, 1'b0,data_in[25]};
  assign d26 = {1'b0,1'b0,1'b0, 1'b0, data_in[26]};
  assign d27 = {1'b0,1'b0,1'b0, 1'b0, data_in[27]};
  assign d28 = {1'b0,1'b0,1'b0, 1'b0, data_in[28]};
  assign d29 = {1'b0,1'b0,1'b0, 1'b0, data_in[29]};
  assign d30 = {1'b0,1'b0,1'b0, 1'b0, data_in[30]};
  assign d31 = {1'b0,1'b0,1'b0, 1'b0, data_in[31]};
  
  
 // Add all the ones 
  
  assign data_out = d0 + d1 + d2 + d3 + d4 + d5 + d6 + d7 + d8 + d9 + d10 + d11 + d12 + d13 + d14 + d15 + d16 + d17 + d18 + d19 + d20 + d21 + d22 + d23 + d24 + d25 + d26 + d27 + d28 + d29 + d30 + d31;
 
 
endmodule