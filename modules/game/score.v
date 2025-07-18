module score (
    input clk, reset,
    input [10:0] timer,
    output reg [6:0] score
);
    localparam TIME_LIMIT = 600;
    localparam MAX_SCORE = 100;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            score <= 7'd0;
        end else begin
            if (timer <= 11'd60) begin
                score <= MAX_SCORE;
            end else if (timer >= TIME_LIMIT) begin
                score <= 7'd0;
            end else begin
                score <= MAX_SCORE - (((timer - 60) * MAX_SCORE) / (TIME_LIMIT - 60));
            end
        end
    end
endmodule
