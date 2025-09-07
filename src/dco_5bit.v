// dco module
// Receives the filter output and generates the proportional time-period
//`include "acs_5bit.v"
module dco_5bit(
  input wire clk,
  input wire reset,
  input wire[4:0] kdco,
  input wire ctrl_sign,
  input wire [4:0] ctrl,
  input wire [4:0] dco_offset,
  input wire [4:0] thresh_val,
  output reg dco_clk
);

  wire [4:0] ctrl_buf;
  wire [4:0] thresh;
  wire [4:0] thresh_buf, thresh_buf2;
  wire thresh_sign;
  wire [4:0] phase;             
  reg [31:0] counter;           

  // 1. Buffer the control input for reset logic
  assign ctrl_buf = (reset) ? 5'd0 : ctrl;

  // 2. Calculate phase (widen to 6 bits to prevent overflow in phase calculation)
  assign phase = (ctrl_buf * kdco)>>1;  // Multiply control value with DCO constant

  // 3. Modulate the DCO threshold based on phase.
  acs_5bit acs0(.sign_in1(1'b0), .in1(thresh_val), .sign_in2((~ctrl_sign)),.in2(phase), .sum(thresh_buf), .sign_out(thresh_sign));
  
  // 4. Add offset to prevent threshold getting negative values   
  assign thresh_buf2 = thresh_buf + dco_offset;
     
  // 5. Saturating threshold handling (clamp between 0 and 31)
  assign thresh = (thresh_sign) ? 5'd0 : (thresh_buf2 > 5'd30) ? 5'd31 : thresh_buf2;
    
  // 6. Update threshold and toggle DCO clock based on the counter
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      dco_clk <= 1'b0;
      counter <= 32'd0;
    end else begin
      // 6.1. Compare the counter data with threshold
      if (counter >= thresh) begin
        // 6.2. Flip the DCO output when threshold is crossed
        dco_clk <= ~dco_clk;               
        // 6.3. Reset counter to offset
        counter <= {27'd0, dco_offset};    
      end else begin
        // 6.4. Increment counter otherwise
        counter <= counter + 1;            
      end
    end
  end 
 
 

endmodule


