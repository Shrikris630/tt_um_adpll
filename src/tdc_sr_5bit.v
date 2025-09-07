//Thermometer coded TDC-based Phase Detector (PD)
// Sequential PD generates up and down signal which is converted to its binary equivalent by TDC
module tdc_sr_5bit(
  input clk,
  input wire reset,
  input wire clk_ref,
  input wire fb_clk,
  output reg[31:0] up_error,
  output reg[31:0] dwn_error);

  reg start;
  reg up,dwn;
  reg reset_trig;

      //-------------------------------------------------------------
    // 1. Generate synchronous reset_trig based on UP & DWN signals
    //-------------------------------------------------------------
  always @(posedge up or posedge dwn) begin
            reset_trig <= up & dwn;  // Reset when both UP and DWN are asserted
    end

    //-------------------------------------------------------------
    // 2. UP detection (sequential PD)
    //-------------------------------------------------------------
    always @(posedge clk_ref or posedge reset_trig) begin
        if (reset_trig)
            up <= 1'b0;
        else
            up <= start;  // Equivalent to 1'b1 & start
    end

    //-------------------------------------------------------------
    // 3. DWN detection (sequential PD)
    //-------------------------------------------------------------
    always @(posedge fb_clk or posedge reset_trig) begin
        if (reset_trig)
            dwn <= 1'b0;
        else
            dwn <= start;
    end

  // 2. TDC Blocks : Convert UP & DWN to thermometer codes 
  always@(posedge clk or posedge reset_trig) begin
    if(reset_trig) begin
      up_error <= 32'd0;
      dwn_error <= 32'd0;
    end
    else begin
      //UP_ERROR : Thermometer code of UP
      up_error[0] <= up;  
      up_error[31:1] <= up_error[30:0];  
      //DWN_ERROR : Thermometer code of UP
      dwn_error[0] <= dwn;  
      dwn_error[31:1] <= dwn_error[30:0]; 
    end      
  end    

  // 3. Start the phase detection after Clock arrival
  always@(posedge clk_ref or posedge reset) begin
    if(reset)
      start <= 1'b0;
    else 
      start <= 1'b1;
  end


endmodule


