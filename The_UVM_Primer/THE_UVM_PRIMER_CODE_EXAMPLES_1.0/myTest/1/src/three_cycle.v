module three_cycle (
    input  [7:0] A,
    input  [7:0] B,
    input        clk,
    input        reset_n,
    input        start,
    output reg   done_mult,
    output reg [15:0] result_mult
);

    // Internal signals
    reg [7:0] a_int, b_int;             // Pipeline stage 1 inputs
    reg [15:0] mult1, mult2;            // Pipeline registers
    reg done3, done2, done1, done_mult_int; // Pipeline done signals

    // Three-stage pipelined multiplier
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            // Asynchronous reset (active low)
            done_mult_int <= 1'b0;
            done3 <= 1'b0;
            done2 <= 1'b0;
            done1 <= 1'b0;

            a_int <= 8'b0;
            b_int <= 8'b0;
            mult1 <= 16'b0;
            mult2 <= 16'b0;
            result_mult <= 16'b0;
        end else begin
            // Pipeline stages
            a_int <= A;
            b_int <= B;
            mult1 <= a_int * b_int;
            mult2 <= mult1;
            result_mult <= mult2;

            // Done signal pipeline
            done3 <= start && !done_mult_int;
            done2 <= done3 && !done_mult_int;
            done1 <= done2 && !done_mult_int;
            done_mult_int <= done1 && !done_mult_int;
        end
    end

    // Assign done signal
    always @(*) begin
        done_mult = done_mult_int;
    end

endmodule
