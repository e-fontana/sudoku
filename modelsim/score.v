module score #(
    parameter TIME_LIMIT_MINUTES = 30
) (
    input clk, reset,
    input [10:0] timer,
    output reg [6:0] score
);
    localparam MAX_SCORE = 100;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            score <= 7'd0;
        end else begin
            if (timer <= 11'd60) begin
                score <= MAX_SCORE;
            end else if (timer >= TIME_LIMIT_MINUTES * 60) begin
                score <= 7'd0;
            end else begin
                score <= MAX_SCORE - (((timer - 60) * MAX_SCORE) / ((TIME_LIMIT_MINUTES * 60) - 60));
            end
        end
    end
endmodule
