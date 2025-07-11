module stopwatch (
    input clk, reset, playing_condition,
    output reg [10:0] timer,

    output [3:0] n0, n1, n2
);
    reg [5:0] seconds;
    reg [3:0] minutes;

    assign n0 = seconds % 10;
    assign n1 = seconds / 10;
    assign n2 = minutes;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            timer <= 11'd0;
            seconds <= 6'd0;
            minutes <= 5'd0;
        end else if (playing_condition) begin
            if (minutes < 5'd30) begin
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
        end else begin
            timer <= 11'd0;
            seconds <= 6'd0;
            minutes <= 5'd0;
        end
    end
endmodule
