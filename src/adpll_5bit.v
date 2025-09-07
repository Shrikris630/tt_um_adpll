// 5-bit ADPLL verilog-code
//`include "tdc_sr_5bit.v"
//`include "ones_counter_5bit.v"
//`include "acs_5bit.v"
//`include "pi_filter_5bit.v"
//`include "dco_5bit.v"
//`include "freq_divider_5bit.v"


module adpll_5bit(
  input wire clk,
  input wire reset,
  input wire clk90,
  input wire clk_ref,
  input wire[3:0]ndiv,
  input wire[4:0]alpha_var,
  input wire[4:0]beta_var,
  input wire[4:0]dco_offset,
  input wire[4:0]dco_thresh_val,
  input wire[4:0]kdco,
  inout fb_clk,
  output [4:0] integ_out,
  output integ_sign,
  inout  [4:0] filter_out,
  inout  filter_sign,
  inout dco_out);
  
  wire[31:0] up_error, dwn_error;
  wire[4:0] bin_up_error, bin_dwn_error, bin_error;
  wire error_sign;
  wire freq_div_buf;
  wire clk2x;

  //1. Generate Sampling clock 2x frequency  
  assign clk2x = clk^clk90;
   
  //2. Phase Detection
  tdc_sr_5bit i0_tdc(.clk(clk),.reset(reset), .clk_ref(clk_ref), .fb_clk(fb_clk), .up_error(up_error), .dwn_error(dwn_error));
  
  //3. Convert the thermometer code to binary
  ones_counter_5bit i1_oc(.data_in(up_error), .data_out(bin_up_error));
  ones_counter_5bit i2_oc(.data_in(dwn_error), .data_out(bin_dwn_error));
  acs_5bit i3_sub(.sign_in1(1'b0), .in1(bin_up_error), .sign_in2(1'b1),.in2(bin_dwn_error), .sum(bin_error), .sign_out(error_sign));
 
  //4. Loop filter 
  pi_filter_5bit i4_pi_filter( .clk(clk), .reset(reset), .error_sign(error_sign), .error(bin_error), .alpha_var(alpha_var), .beta_var(beta_var), .integ_out(integ_out), .integ_sign(integ_sign), .filter_out(filter_out), .filter_sign(filter_sign));      

  //5. dco
  dco_5bit i5_dco(.clk(clk2x), .reset(reset), .kdco(kdco), .ctrl_sign(filter_sign), .ctrl(filter_out),.dco_offset(dco_offset), .thresh_val(dco_thresh_val),.dco_clk(dco_out));
  
  //6. Frequency divider
  freq_divider_5bit i6_freq_div(.clk(dco_out), .reset(reset), .ndiv(ndiv), .freq_div_out(freq_div_buf));
  
  //7. Mux out the frequecy divider or dco output directly
  assign fb_clk = (ndiv==4'd0)?dco_out:freq_div_buf;
  
endmodule

