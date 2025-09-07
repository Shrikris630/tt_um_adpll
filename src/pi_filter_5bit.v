
// 5-bit PI filter
// Receives the phase-error and takes its average
//`include "acs_5bit.v"
module pi_filter_5bit(
  input wire clk,
  input wire reset,
  input wire error_sign,
  input wire [4:0]error,
  input wire [4:0]alpha_var,
  input wire [4:0]beta_var,
  output [4:0]integ_out,
  output integ_sign,
  output [4:0]filter_out,
  output filter_sign);
  
  reg [4:0]integ_store;
  reg integ_store_sign;
  wire [4:0]integ_var;
  wire [4:0]prop_var;
 
 
  //1, Proportional Path
  assign prop_var = error*beta_var;

  //2. integral path
  assign integ_var = error*alpha_var;
  
  // 2.1. Delay the data
  always@(posedge clk or posedge reset) begin
    if(reset) begin
      integ_store <=5'd0;
      integ_store_sign <= 1'b0;
    end
    else begin    
      integ_store <= integ_out;
      integ_store_sign <= integ_sign;
    end   
  end 

  // 2.2. Add the delayed data with 
  acs_5bit acs0(.sign_in1(error_sign), .in1(integ_var), .sign_in2(integ_store_sign),.in2(integ_store), .sum(integ_out), .sign_out(integ_sign));

  //3. filter_out
  acs_5bit acs1(.sign_in1(error_sign), .in1(prop_var), .sign_in2(integ_sign),.in2(integ_out), .sum(filter_out), .sign_out(filter_sign));
  

endmodule  
