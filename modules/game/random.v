// Módulo 'random' melhorado com LFSR
module random(
    input clk,
    input reset,
    input map_loaded,
    output reg [2:0] random_number
);
    // LFSR de 3 bits com realimentação de X^3 + X^2 + 1 (tap nos bits 2 e 1)
    wire feedback = random_number[2] ^ random_number[1];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            random_number <= 3'b001; // Inicia com um valor não-zero
        end else if (~map_loaded) begin
            // Desloca os bits e insere o feedback
            random_number <= {random_number[1:0], feedback};
        end
    end
endmodule