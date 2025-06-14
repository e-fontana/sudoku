module moduleName (
    input clk,
    input reset,
    output reg [3:0] random_number
);

    reg [3:0] seed;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            seed <= 4'b0001; // Initial seed value
        end else begin
            // Simple linear feedback shift register (LFSR) for pseudo-random number generation
            seed <= {seed[2:0], seed[3] ^ seed[1]};
        end
    end

    always @(posedge clk) begin
        random_number <= seed; // Output the current seed as the random number
    end
);
    
endmodule