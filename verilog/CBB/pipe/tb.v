`timescale 1ns / 1ps

module BlockPipe_tb;

    // Testbench signals
    reg clk;
    reg rst_n;
    reg valid_i;
    reg [31:0] data_i;
    wire ready_o;
    reg ready_i;
    wire valid_o;
    wire [31:0] data_o;

    // Instantiate the DUT (Device Under Test)
    BlockPipe uut (
        .clk(clk),
        .rst_n(rst_n),
        .valid_i(valid_i),
        .data_i(data_i),
        .ready_o(ready_o),
        .ready_i(ready_i),
        .valid_o(valid_o),
        .data_o(data_o)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Reset generation
    initial begin
        rst_n = 0;
        #20; // Hold reset low for 20ns
        rst_n = 1;
    end

    // Stimulus generation
    initial begin
        // Initialize inputs
        valid_i = 0;
        data_i = 0;
        ready_i = 0;

        // Wait for reset deassertion
        @(posedge rst_n);

        // Test case 1: Send a single valid input
        @(posedge clk);
        valid_i <= 1;
        data_i <= 32'hA5A5A5A5; // Example input data
        ready_i = 1;

        @(posedge clk);
        valid_i <= 0; // Deassert valid after one cycle

        // Wait for output to become valid
        wait(valid_o);
        $display("Output data: %h", data_o);

        // Test case 2: Send multiple inputs
        repeat (25) begin
            @(posedge clk);
            valid_i <= 1;
            data_i = $random; // Random input data
            @(posedge clk);
            valid_i <= 0;
        end

        // Wait for all outputs to be processed
        wait(!valid_o);
        $finish; // Finish simulation
    end
    initial begin
        $dumpfile("tb.vcd");        
        $dumpvars(0);
        #5000 $finish;
    end
endmodule