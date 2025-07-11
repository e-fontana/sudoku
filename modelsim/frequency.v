module game_frequency(
    input clk,
    input reset,
    output reg game_clk 
);
    localparam CLK_FREQ = 50_000_000 - 1;
    reg [25:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            game_clk <= 1'b0;
            counter <= 1'b0;
        end else if (counter == CLK_FREQ / 3) begin
            game_clk <= ~game_clk;
            counter <= 1'b0;
        end else begin
            counter <= counter + 1'b1;
        end
    end
endmodule