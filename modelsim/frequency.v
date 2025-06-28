module frequency (
    input clk,
    input reset,
    output reg clk_1Hz 
);
    localparam CLK_FREQ = 4;
    reg [25:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            clk_1Hz <= 0;
            counter <= 0;
        end else if (counter == CLK_FREQ) begin
            clk_1Hz <= ~clk_1Hz;
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end
endmodule