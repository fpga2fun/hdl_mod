module dff (
    output logic q,
    q_l,
    input  logic clk,
    d,
    reset_l
);

  always @(posedge clk or negedge reset_l) begin
    q   <= d;
    q_l <= !d;
  end
endmodule
