module random(
    input clk,
    input reset,
    output reg [2:0] random_number
);
    reg [2:0] seed;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            seed <= 3'b001;
        end else begin
            seed <= {seed[1:0], seed[2] ^ seed[0]};
        end
    end

    always @(posedge clk) begin
        random_number <= seed;
    end
endmodule