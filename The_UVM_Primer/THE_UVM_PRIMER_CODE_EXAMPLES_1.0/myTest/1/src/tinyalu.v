module tinyalu (
    input  [7:0] A,
    input  [7:0] B,
    input        clk,
    input  [2:0] op,
    input        reset_n,
    input        start,
    output       done,
    output reg [15:0] result
);

    // Internal signal declarations
    wire done_aax;
    wire done_mult;
    wire [15:0] result_aax;
    wire [15:0] result_mult;
    reg start_single;
    reg start_mult;
    reg done_internal;

    // Start signal demultiplexer
    always @(*) begin
        case (op[2])
            1'b0: begin
                start_single = start;
                start_mult   = 1'b0;
            end
            1'b1: begin
                start_single = 1'b0;
                start_mult   = start;
            end
            default: begin
                start_single = 1'b0;
                start_mult   = 1'b0;
            end
        endcase
    end

    // Result multiplexer
    always @(*) begin
        case (op[2])
            1'b0: result = result_aax;
            1'b1: result = result_mult;
            default: result = 16'h0000;
        endcase
    end

    // Done signal multiplexer
    always @(*) begin
        case (op[2])
            1'b0: done_internal = done_aax;
            1'b1: done_internal = done_mult;
            default: done_internal = 1'bX;
        endcase
    end

    // Assign done signal
    assign done = done_internal;

    // Instance of single_cycle module
    single_cycle add_and_xor (
        .A(A),
        .B(B),
        .clk(clk),
        .op(op),
        .reset_n(reset_n),
        .start(start_single),
        .done_aax(done_aax),
        .result_aax(result_aax)
    );

    // Instance of three_cycle module
    three_cycle mult (
        .A(A),
        .B(B),
        .clk(clk),
        .reset_n(reset_n),
        .start(start_mult),
        .done_mult(done_mult),
        .result_mult(result_mult)
    );

endmodule
