module Dff(input clk, rst_n, data_in, output reg data_out);
    always@(posedge clk, negedge rst_n) begin
        if(!rst_n)
            data_out <= 1'b0;
        else
            data_out <=  data_in;
    end
endmodule
