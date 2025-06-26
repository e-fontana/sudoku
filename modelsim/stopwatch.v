module stopwatch (
    input clk,
    input reset,
    output reg [6:0] timer
);
    always @(posedge clk) begin
        if (reset) begin
            timer <= 0;
        end else if (timer < 1800) begin
            timer <= timer + 1;
        end
    end
endmodule
