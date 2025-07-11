module frequency #(
    parameter COUNTER_LIMIT = 50_000_000 - 1
) (
    input clk,
    input reset,
    output reg out_clk 
);  
    reg [25:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out_clk <= 0;
            counter <= 0;
        end else if (counter == COUNTER_LIMIT) begin
            out_clk <= ~out_clk;
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end
endmodule