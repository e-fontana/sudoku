module stopwatch (
    input clk,
    input reset,
    input playing_condition,
    output reg [10:0] timer,
    output reg [5:0] seconds,
    output reg [4:0] minutes
);
    wire clk_1Hz;

    parameter COUNTER_LIMIT = (50_000_000 - 1) / 2; // 1 second at 50 MHz

    frequency #(
        .COUNTER_LIMIT(COUNTER_LIMIT)
    ) fd (
        .clk(clk),
        .reset(reset),
        .out_clk(clk_1Hz)
    );

    always @(posedge clk_1Hz or posedge reset) begin
        if (reset) begin
            timer <= 11'd0;
            seconds <= 6'd0;
            minutes <= 5'd0;
        end else begin
            if (playing_condition) begin
                if (seconds == 6'd59) begin
                    seconds <= 6'd0;
                    minutes <= minutes + 5'd1;
                end else begin
                    seconds <= seconds + 6'd1;
                end

                timer <= timer + 11'd1;
            end else begin
                timer <= timer;
                seconds <= seconds;
                minutes <= minutes;
            end
        end
    end
endmodule
