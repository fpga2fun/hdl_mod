module BlockPipe(
        input           clk,
        input           rst_n,
        //upstream
        input           valid_i,
        input [31:0]    data_i,
        output          ready_o,
        //downstream
        input           ready_i,
        output          valid_o,
        output [31:0]   data_o
    );
    //pipeline signals
    reg         pipe1_valid;
    reg [31:0]  pipe1_data;
    wire        pipe1_ready,pipe1_done;

    reg         pipe2_valid;
    reg [31:0]  pipe2_data;
    wire        pipe2_ready,pipe2_done;

    reg         pipe3_valid;
    reg [31:0]  pipe3_data;
    wire        pipe3_ready,pipe3_done;

    wire        pipe1_2_pipe2_valid;
    wire        pipe2_2_pipe3_valid;

    reg [1:0]   mul_done;
    wire [31:0] mul_result;

    //pipeline 1 stage
    assign pipe1_done = 1'b1;
    assign pipe1_ready = !pipe1_valid || (pipe1_done && pipe2_ready);
    assign pipe1_2_pipe2_valid = pipe1_valid & pipe1_done;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            pipe1_valid <= 1'b0;
        else if(pipe1_ready)
            pipe1_valid <= valid_i;
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            pipe1_data <= 32'h0;
        else if(valid_i && pipe1_ready)
            pipe1_data <= data_i;
    end

    //pipeline 2 stage
    assign pipe2_done = mul_done[1];
    assign pipe2_ready = !pipe2_valid || (pipe2_done && pipe3_ready);
    assign pipe2_2_pipe3_valid = pipe2_valid & pipe2_done;
    assign mul_result = pipe2_data * 4'h5;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            mul_done <= 2'b00;
        else if(pipe2_ready && pipe1_2_pipe2_valid)
            mul_done <= 2'b00;
        else if(pipe2_valid)
            mul_done <= {mul_done[1:0],1'b1};
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            pipe2_valid <= 1'b0;
        else if(pipe2_ready)
            pipe2_valid <= pipe1_2_pipe2_valid;
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            pipe2_data <= 32'h0;
        else if(pipe1_2_pipe2_valid && pipe2_ready)
            pipe2_data <= pipe1_data + 4'h4;
    end
    //pipeline 3 stage
    assign pipe3_done = 1'b1;
    assign pipe3_ready = !pipe3_valid || (pipe3_done && ready_i);

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            pipe3_valid <= 1'b0;
        else if(pipe3_ready)
            pipe3_valid <= pipe2_2_pipe3_valid;
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            pipe3_data <= 32'h0;
        else if(pipe2_2_pipe3_valid && pipe3_ready)
            pipe3_data <= mul_result;
    end

    assign valid_o = pipe3_valid;
    assign data_o =pipe3_data;
    assign ready_o = pipe1_ready;


endmodule
