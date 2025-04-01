///////////////////////////////////////////////////////
// Purpose: DUT for Chap_2_Data_Types/homework3_solution
//          Contains 1 bug/register
// Author: Greg Tumbush
//
// REVISION HISTORY:
// $Log: config_reg_buggy.sv,v $
// Revision 1.1  2011/05/28 19:48:17  tumbush.tumbush
// Check into cloud repository
//
// Revision 1.1  2011/03/17 15:56:34  Greg
// Initial check-in
//
///////////////////////////////////////////////////////
  module config_reg(
		input  logic clk,
		input  logic reset,
		input  logic write,
		input  logic [15:0] data_in,
		input  logic [2:0] address,
		output logic [15:0] data_out
);

`protect

  // The bugs are:
  // 1) adc0_reg: MSB is fixed at 1 in read logic
  // 2) adc1_reg; bytes are swapped in write logic
  // 3) temp_sensor0_reg: shifted left by 1 in read logic
  // 4) temp_sensor1_reg; Needs to be included in reset and declared as type logic
  // 5) analog_test: Resets to wrong value
  // 6) digital_test: Written when address = 6, should be 5
  // 7) amp_gain: Written when address = 5, should be 6    
  // 8) digital_config: Declared as only 15-bits wide

   
   logic [15:0]	       adc0_reg;
   logic [15:0]        adc1_reg;
   logic [15:0]        temp_sensor0_reg;
   bit   [15:0]        temp_sensor1_reg;  // 4) temp_sensor1_reg; Needs to be included in reset and declared as type logic
   logic [15:0]        analog_test;
   logic [15:0]        digital_test;
   logic [15:0]        amp_gain;
   logic [14:0]        digital_config;   // 8) digital_config: Declared as only 15-bits wide

   // Write mux
   always @(posedge clk or posedge reset) begin
      if (reset) begin // 4) temp_sensor1_reg; Needs to be included in reset and declared as type logic
	 adc0_reg<=16'hFFFF;
	 adc1_reg<=16'h0000; 
	 temp_sensor0_reg<=16'h0;
	 analog_test<=16'hABCC;   // 5) analog_test: Resets to wrong value
	 digital_test<=16'h0; 
	 amp_gain<=16'h0;
	 digital_config<=16'h1;
      end
      else if (write) begin
	 case(address)
	    3'h0: adc0_reg <= data_in;    
            3'h1: adc1_reg<= {data_in[7:0], data_in[15:8]};  // 2) adc1_reg; bytes are swapped in write logic
	    3'h2: temp_sensor0_reg <= data_in;
	    3'h3: temp_sensor1_reg <= data_in;
	    3'h4: analog_test <= data_in;
	    3'h6: digital_test <= data_in;            // 6) digital_test: Written when address = 6, should be 5
            3'h5: amp_gain <= data_in;       	      // 7) amp_gain: Written when address = 5, should be 6    
	    3'h7: digital_config <= data_in;       
	 endcase // case (address) 
      end // else: !if(!reset)
   end // always @ (posedge clk or posedge reset)
	    
   // Read mux
   always @* begin
      case(address)
	 3'h0: data_out = {1'b1, adc0_reg[14:0]};  // 1) adc0_reg: MSB is fixed at 1 in read logic
	 3'h1: data_out = adc1_reg;                
	 3'h2: data_out = {temp_sensor0_reg[14:0], 1'b0}; // 3) temp_sensor0_reg: shifted left by 1 in read logic
	 3'h3: data_out = temp_sensor1_reg;
	 3'h4: data_out = analog_test;     
	 3'h5: data_out = digital_test;    
         3'h6: data_out = amp_gain;        
	 3'h7: data_out = digital_config;   
        default: data_out = 16'h0;    
      endcase // case (address) 
   end
`endprotect   

endmodule // test

