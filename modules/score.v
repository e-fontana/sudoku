module score (
    input clk,
    input [10:0] timer,
    input playing_condition,
    output reg [6:0] score
);
    always @(posedge clk) begin
        if (!playing_condition) begin
            score <= 0; // Reset score when not playing
        end else begin
            if (timer <= 60) begin
                score <= 100;
            end else if (timer >= 1800) begin
                score <= 0;
            end else begin
                score <= 100 - (((timer - 60) * 100) / 1740);
            end
        end
    end
endmodule
