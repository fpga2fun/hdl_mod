module pipe_skid_buffer #(
        parameter DWIDTH = 8 // Data width
    )(
        input clk,                   // Clock
        input rstn,                  // Active-low synchronous reset

        // Input Interface
        input [DWIDTH-1:0] i_data,   // Data in
        input i_valid,               // Data in valid
        output i_ready,              // Ready out

        // Output Interface
        output [DWIDTH-1:0] o_data,  // Data out
        output o_valid,              // Data out valid
        input o_ready                // Ready in
    );

    // State encoding
    localparam PIPE = 1'b0;
    localparam SKID = 1'b1;

    // Internal Registers/Signals
    reg state_rg;
    reg [DWIDTH-1:0] data_rg, sparebuff_rg;
    reg valid_rg, sparebuff_valid_rg, ready_rg;
    wire ready;

    // Synchronous logic
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            state_rg           <= PIPE;
            data_rg            <= {DWIDTH{1'b0}};
            sparebuff_rg       <= {DWIDTH{1'b0}};
            valid_rg           <= 1'b0;
            sparebuff_valid_rg <= 1'b0;
            ready_rg           <= 1'b0;
        end
        else begin
            case (state_rg)
                PIPE: begin
                    if (ready) begin
                        data_rg            <= i_data;
                        valid_rg           <= i_valid;
                        ready_rg           <= 1'b1;
                    end
                    else begin
                        sparebuff_rg       <= i_data;
                        sparebuff_valid_rg <= i_valid;
                        ready_rg           <= 1'b0;
                        state_rg           <= SKID;
                    end
                end
                SKID: begin
                    if (ready) begin
                        data_rg  <= sparebuff_rg;
                        valid_rg <= sparebuff_valid_rg;
                        ready_rg <= 1'b1;
                        state_rg <= PIPE;
                    end
                end
            endcase
        end
    end

    // Continuous Assignments
    assign ready   = o_ready | ~valid_rg;
    assign i_ready = ready_rg;
    assign o_data  = data_rg;
    assign o_valid = valid_rg;

endmodule
