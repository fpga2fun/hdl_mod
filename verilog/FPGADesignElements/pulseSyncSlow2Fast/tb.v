`timescale 1ns / 1ns // Time unit/precision

module tb_sync_pulse();

localparam SYNC_STAGE = 2; // Synchronization stages

// Signals in the source clock domain (before synchronization)
reg clk_source; // Source clock (slow clock)
reg rst_source; // Active-high synchronous reset
reg sig_pulse_source; // Pulse signal before synchronization
// Signals in the destination clock domain (after synchronization)
reg clk_dest; // Destination clock (fast clock)
reg rst_dest; // Active-high synchronous reset
wire sig_pulse_dest; // Pulse signal after synchronization

reg [9:0] period_source; // Period of the source clock, random value, 0-1024ns
reg [9:0] period_dest; // Period of the destination clock, random value, less than half of the source clock period

// Generate source clock
initial begin
	period_source = {$random%6};
	clk_source = 1'b0;
	// #({$random%1024}); // Add a random phase to make the two clocks completely asynchronous
	forever begin
		#period_source;
		clk_source = ~clk_source;
	end
end

// Generate destination clock
initial begin
	period_dest = {$random%(period_source/2)};
	clk_dest = 1'b0;
	// #({$random%1024}); // Add a random phase to make the two clocks completely asynchronous
	forever begin
		#period_dest;
		clk_dest = ~clk_dest;
	end
end

// Generate reset signal for the source clock
initial begin
	rst_source = 1'b1; // Active on power-up
	@(posedge clk_source);
	@(posedge clk_source);
    #2;
	rst_source = 1'b0; // Ensure it remains active for at least one clock cycle before release
end

// Generate reset signal for the destination clock
initial begin
	rst_dest = 1'b1; // Active on power-up
	@(posedge clk_dest);
	@(posedge clk_dest);
    #2;
	rst_dest = 1'b0; // Ensure it remains active for at least one clock cycle before release
end

initial begin
	sig_pulse_source = 1'b0;
	@(negedge rst_dest); // Wait for reset to complete
	repeat(10) begin // Randomly generate pulse signals, execute 10 times
		@(posedge clk_source);
		sig_pulse_source = $random;
		@(posedge clk_source);
		sig_pulse_source = 1'b0;
	end
	$stop();
end

// Instantiate the module under test
sync_pulse #(
	.SYNC_STAGE (SYNC_STAGE)
)
u_sync_pulse
(
	.clk_source (clk_source),	
	.rst_source (rst_source),	
	.sig_pulse_source (sig_pulse_source),		
	.clk_dest (clk_dest),	
	.rst_dest (rst_dest),	
	.sig_pulse_dest (sig_pulse_dest)	
);

endmodule