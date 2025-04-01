module single_cycle (
    input  [7:0] A,
    input  [7:0] B,
    input        clk,
    input  [2:0] op,
    input        reset_n,
    input        start,
    output reg   done_aax,
    output reg [15:0] result_aax
);

    // Internal signals
    reg done_aax_int;

    // Main operations process
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            // Synchronous Reset
            result_aax <= 16'b0;
        end else if (start) begin
            case (op)
                3'b001: result_aax <= {8'b0, A} + {8'b0, B}; // Addition
                3'b010: result_aax <= {8'b0, A} & {8'b0, B}; // AND operation
                3'b011: result_aax <= {8'b0, A} ^ {8'b0, B}; // XOR operation
                default: result_aax <= result_aax;           // No operation
            endcase
        end
    end

    // Done signal process
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            done_aax_int <= 1'b0;
        end else if (start && op != 3'b000) begin
            done_aax_int <= 1'b1;
        end else begin
            done_aax_int <= 1'b0;
        end
    end

    // Assign done signal
    always @(*) begin
        done_aax = done_aax_int;
    end

endmodule
