module frequency (
    input clk_50MHz,
    output reg clk_1Hz 
);
    reg [25:0] counter = 0;  

    always @(posedge clk_50MHz) begin
        if (counter == 49_999_999) begin
            clk_1Hz <= ~clk_1Hz;
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end
endmodule