module stopwatch_frequency(
    input clk,
    input reset,
    output reg stopwatch_clk 
);
    localparam CLK_FREQ = 50_000_000 - 1;
    reg [25:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stopwatch_clk <= 1'b0;
            counter <= 1'b0;
        end else if (counter == CLK_FREQ) begin
            stopwatch_clk <= ~stopwatch_clk;
            counter <= 1'b0;
        end else begin
            counter <= counter + 1'b1;
        end
    end
endmodule