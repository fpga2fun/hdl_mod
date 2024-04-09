module alu(input logic [31:0] a, b, 
 input logic [1:0] ALUControl, 
 output logic [31:0] Result); 
 logic [31:0] condinvb; 
 logic [32:0] sum; 
 assign condinvb = ALUControl[0] ? ~b : b; 
 assign sum = a + condinvb + ALUControl[0]; 
 always_comb 
 casex (ALUControl[1:0]) 
 2'b0?: Result = sum; 
 2'b10: Result = a & b; 
 2'b11: Result = a | b; 
 endcase 
endmodule 