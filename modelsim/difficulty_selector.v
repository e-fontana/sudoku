module difficulty_selector #(
    parameter [2:0] SELECIONAR_DIFICULDADE = 3'b001
) (
    input clk,
    input reset,
    input up_button,
    input down_button,
    input [2:0] current_state,
    output reg difficulty
);
    reg next_difficulty;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            difficulty <= 1'b0; // Default to easy difficulty
        end else begin
            difficulty <= next_difficulty;
        end
    end

    always @(*) begin
        next_difficulty = difficulty; // Default to current difficulty

        if (current_state == SELECIONAR_DIFICULDADE) begin
            if (up_button) begin
                next_difficulty = 1'b0; // Easy difficulty
            end
            
            if (down_button) begin
                next_difficulty = 1'b1; // Hard difficulty
            end
        end
    end
endmodule