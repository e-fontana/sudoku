module random (
    input clk,
    input reset,
    output reg [3:0] random_number
);
    reg [3:0] seed;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            seed <= 4'b0001;
        end else begin
            seed <= {seed[2:0], seed[3] ^ seed[1]};
        end
    end

    always @(posedge clk) begin
        random_number <= seed;
    end
endmodule