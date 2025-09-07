// Programmable frequency divider
module freq_divider_5bit(
  input wire clk,
  input wire reset,
  input wire [3:0]ndiv,
  output reg freq_div_out);
  
  wire [3:0] thresh;
  reg [31:0] counter;
  
 
 // 1. Left shift ndiv considering half the time-period
  assign thresh = ndiv >> 1;
  
  always@(posedge clk or posedge reset ) begin
    if(reset) begin
      counter <= 32'd0;
      freq_div_out <= 0;
    end
    else begin
      //2. Compare the counter with threshold
      if(counter >= thresh) begin
        // 3. Toggle frequency divider output if counter >= threshold
        freq_div_out <= ~freq_div_out;
        // 4. Reset the counter if counter >= threshold
        counter <= 32'd0;
      end
      else begin
        // 6. Increment counter if not true
        counter <= counter + 1;
      end
    end
  end   
endmodule  
