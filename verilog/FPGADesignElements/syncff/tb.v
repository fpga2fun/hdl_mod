`timescale 1ns / 1ns			// Time unit / precision
module tb_sync_level();
localparam	SYNC_STAGE = 3;		// Number of synchronization stages
// Signals in the source clock domain (i.e., signals before synchronization)
reg		clk_source			;	// Source clock (slow clock)
reg		rst_source			;	// Active-high synchronous reset
reg		sig_level_source	;	// Signal level before synchronization
// Signals in the destination clock domain (i.e., signals after synchronization)		
reg		clk_dest			;	// Destination clock (fast clock)
reg		rst_dest			;	// Active-high synchronous reset
wire	sig_level_dest		;	// Signal level after synchronization
reg	[9:0]	period_source	;	// Period of the source clock, random value, 0-1024ns
reg	[9:0]	period_dest		;	// Period of the destination clock, random value, less than half of the source clock period, ensuring a 2x frequency relationship
// Generate the source clock
initial begin
    period_source = {$random%1024};	
    clk_source = 1'b0;
//	#({$random%1024});				// Add a random phase to make the two clocks completely asynchronous
    forever begin
        #period_source;
        clk_source = ~clk_source;
    end
end 
// Generate the destination clock
initial begin
    period_dest = {$random%(period_source/2)};	
    clk_dest = 1'b0;	
//	#({$random%1024});				// Add a random phase to make the two clocks completely asynchronous
    forever begin
        #period_dest;
        clk_dest = ~clk_dest;
    end
end
// Generate the reset signal for the source clock
initial begin
    rst_source = 1'b1;		// Reset is active upon power-up
    @(posedge clk_source);
    @(posedge clk_source);	
    rst_source = 1'b0;		// Ensure it remains active for at least one clock cycle before release
end
// Generate the reset signal for the destination clock
initial begin
    rst_dest = 1'b1;		// Reset is active upon power-up
    @(posedge clk_dest);
    @(posedge clk_dest);	
    rst_dest = 1'b0;		// Ensure it remains active for at least one clock cycle before release
end
 
initial begin
    sig_level_source = 1'b0;
    @(negedge rst_dest);	// Wait for reset to complete
    @(negedge clk_source);
 
    // Generate a signal level that lasts for 5 clock cycles
    @(posedge clk_source);
    sig_level_source = 1'b1;
    @(posedge clk_source);
    @(posedge clk_source);
    @(posedge clk_source);
    @(posedge clk_source);
    @(posedge clk_source);
    sig_level_source = 1'b0;
    
    @(posedge clk_source);
    @(posedge clk_source);
    $stop();
end
 
// Instantiate the module under test
sync_level #(
    .SYNC_STAGE			(SYNC_STAGE			)
)
u_sync_level
(
    .clk_source			(clk_source			),	
    .rst_source			(rst_source			),	
    .sig_level_source	(sig_level_source	),		
    .clk_dest			(clk_dest			),	
    .rst_dest			(rst_dest			),	
    .sig_level_dest		(sig_level_dest		)	
);
 
endmodule