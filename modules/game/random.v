module random(
    input clk,
    input reset,
    input map_loaded,
    output reg [2:0] random_number
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            random_number <= 3'b000;
        end else if (~map_loaded) begin
            random_number <= random_number + 3'b001;
        end
    end
endmodule