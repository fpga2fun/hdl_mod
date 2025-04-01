module sync_pulse #(
	parameter	SYNC_STAGE = 3			// Number of synchronization stages, typically set to 2. For higher frequencies, it can be set to 3.
)
(
// Signals in the source clock domain (before synchronization)
	input		clk_source			,	// Source clock (slow clock)
	input		rst_source			,	// Active-high synchronous reset
	input		sig_pulse_source	,	// Pulse signal before synchronization
// Signals in the destination clock domain (after synchronization)		
	input		clk_dest			,	// Destination clock (fast clock)
	input		rst_dest			,	// Active-high synchronous reset
	output	reg	sig_pulse_dest			// Pulse signal after synchronization
);

// Define registers
reg	[SYNC_STAGE : 0]	sig_pulse_ff		;	// Synchronization registers. Add 1 to the number of stages because the first stage is unstable. Use the second and third stages to detect rising edges.
reg						sig_pulse_source_d1	;	// Register the original signal in the source clock domain to ensure it is sequential logic, not combinational logic.

// Register the original signal in the source clock domain to ensure it is sequential logic, avoiding glitches in combinational logic that can cause issues and reduce MTBF.
always @(posedge clk_source)begin
	if(rst_source)
		sig_pulse_source_d1 <= 1'b0;
	else
		sig_pulse_source_d1 <= sig_pulse_source;
end

// Synchronize the registered signal to the destination clock domain using a multi-stage synchronizer.
always @(posedge clk_dest)begin
	if(rst_dest)
        sig_pulse_ff <= {(SYNC_STAGE+1){1'b0}};	// This avoids warnings.
	else
		sig_pulse_ff <= {sig_pulse_ff[SYNC_STAGE-1:0],sig_pulse_source_d1};
end

// Extract the rising edge as the synchronized pulse signal. It is better to use sequential logic here.
always @(posedge clk_dest)begin
	if(rst_dest)
		sig_pulse_dest <= 1'b0;
	else
		sig_pulse_dest <= ~sig_pulse_ff[SYNC_STAGE] && sig_pulse_ff[SYNC_STAGE-1];	// Detect rising edge
end

endmodule