// Top level module of adpll as a chip
// In tiny tapeout we can have 8 input, 8 output, 8 bidirectional, clk and rst pins

//`include "adpll_5bit.v"
module adpll_top(
  input wire clk,
  input wire rst, 
  input wire clk90, 
  input wire clk_ref,
  input wire clr,
  input wire pgm,
  input wire out_sel,
  input wire [2:0]param_sel, 
  inout fb_clk,
  inout dco_out,
  inout  [4:0]pgm_value,
  output [4:0] dout,
  output sign);
  
  
 
  reg[4:0]alpha_var_buf;
  reg[4:0]beta_var_buf;
  reg[4:0]dco_offset_buf;
  reg[4:0]dco_thresh_buf;
  reg[4:0]kdco_buf;
  reg[3:0]ndiv;
  wire[4:0]filter_out;
  wire[4:0]integ_out;
  wire filter_sign;
  wire integ_sign;
  wire alpha_en, beta_en,dco_offset_en,dco_thresh_en,kdco_en,ndiv_ld;
  
  
  
 
   
   //pgm mode : pgm all PLL the parameters
   // pgmming is done in cycle by cycle manner, where we can sequentially pgm below
   //  *** frequency divider ***
   //  1. frequency division for frequency divider block
   //  *** Loop Filter parameters ***
   //  2. alpha
   //  3. beta
   //  **** dco parameters ***
   //  4. dco_offst
   //  5. dco_thresold
   //  6. dco_gain
   
   // Select the pgmming option
   assign ndiv_ld = (pgm) ? (param_sel==3'd0)?1:0:0;
   assign alpha_en = (pgm) ? (param_sel==3'd1)?1:0:0;
   assign beta_en = (pgm) ? (param_sel==3'd2)?1:0:0;
   assign dco_offset_en = (pgm) ? (param_sel==3'd3)?1:0:0;
   assign dco_thresh_en = (pgm) ? (param_sel==3'd4)?1:0:0;
   assign kdco_en = (pgm) ? (param_sel==3'd5)?1:0:0;


   // outputs filter data or integrator's data based on out_sel variable 
   assign {sign, dout} = (out_sel) ?{integ_sign,integ_out}:{filter_sign, filter_out};

  adpll_5bit u0( .clk(clk), .reset(rst), .clk90(clk90), .clk_ref(clk_ref),.ndiv(ndiv),.alpha_var(alpha_var_buf),.beta_var(beta_var_buf),.dco_offset(dco_offset_buf), .dco_thresh_val(dco_thresh_buf), .kdco(kdco_buf), .fb_clk(fb_clk), .integ_out(integ_out), .integ_sign(integ_sign), .filter_out(filter_out),.filter_sign(filter_sign), .dco_out(dco_out));
       
       
  // Perform pgmming    
  always@(posedge ndiv_ld or posedge clr) begin
     if(~clr) 
       ndiv <= pgm_value[3:0];
     else
       ndiv <= 4'd0;  
   end
   
  always@(posedge alpha_en or posedge clr) begin
     if(~clr)
       alpha_var_buf <= pgm_value;
     else
       alpha_var_buf <= 5'd0;
   end
   
  always@(posedge beta_en or posedge clr) begin
    if(~clr)
      beta_var_buf <= pgm_value;
    else
      beta_var_buf <= 5'd0;
   end
     
  always@(posedge dco_offset_en or posedge clr) begin
     if(~clr)
       dco_offset_buf <= pgm_value;
     else
       dco_offset_buf <= 5'd0;
   end
         
  always@(posedge dco_thresh_en or posedge clr) begin
     if(~clr) 
       dco_thresh_buf <= pgm_value;
     else
       dco_thresh_buf <= 5'd0;
   end    
     
  always@(posedge kdco_en or posedge clr) begin
     if(~clr)
       kdco_buf <= pgm_value;
     else
       kdco_buf <= 5'd0;  
   end
   
endmodule   


