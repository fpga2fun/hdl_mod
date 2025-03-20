module sync_level #(
    parameter	SYNC_STAGE = 2			// Number of synchronization stages, typically set to 2. For higher frequencies, it can be set to 3.
)
(
// Signal in the source clock domain (i.e., the signal before synchronization)
    input		clk_source			,	// Source clock (slow clock)
    input		rst_source			,	// Active-high synchronous reset
    input		sig_level_source	,	// Signal level before synchronization
// Signal in the destination clock domain (i.e., the signal after synchronization)		
    input		clk_dest			,	// Destination clock (fast clock)
    input		rst_dest			,	// Active-high synchronous reset
    output		sig_level_dest			// Signal level after synchronization
);
 
// Define registers
reg	[SYNC_STAGE - 1 : 0]	sig_level_ff		;		// Synchronization registers, the number of stages depends on SYNC_STAGE
reg							sig_level_source_d1	;		// Latch the original signal in the source clock domain to ensure it is sequential logic instead of combinational logic
assign sig_level_dest = sig_level_ff[SYNC_STAGE - 1];	// Signal level after synchronization
// Latch the original signal in the source clock domain to ensure it is sequential logic instead of combinational logic.
// Combinational logic may have glitches, which can cause issues and reduce MTBF.
always @(posedge clk_source)begin
    if(rst_source)
        sig_level_source_d1 <= 1'b0;
    else
        sig_level_source_d1 <= sig_level_source;
end
// Synchronize the latched signal to the destination clock domain using a multi-stage synchronizer
always @(posedge clk_dest)begin
    if(rst_dest)
        sig_level_ff <= {(SYNC_STAGE){1'b0}};	// This syntax avoids warnings
    else
        sig_level_ff <= {sig_level_ff[SYNC_STAGE-2:0],sig_level_source_d1};
end
endmodule