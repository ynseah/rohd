/**
 * Generated by ROHD - www.github.com/intel/rohd
 * Generation time: 2022-10-25 17:27:39.219314
 */

module Counter(
input logic en,
input logic reset,
input logic clk,
output logic [7:0] val
);
logic [7:0] nextVal;
//  sequential
always_ff @(posedge clk) begin
  if(reset) begin
      val <= 8'h0;
  end else begin
      if(en) begin
          val <= nextVal;
      end 

  end 

end

assign nextVal = val + 8'h1;  // add
endmodule : Counter