module position_updater #(
    parameter CORRENDO_MAPA = 3'b011
) (
    input clk,
    input reset,

    input up_button,
    input down_button,
    input left_button,
    input right_button,

    input [2:0] current_state,

    output reg [3:0] pos_i,
    output reg [3:0] pos_j
);
    reg [3:0] next_pos_i, next_pos_j;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pos_i <= 4'd4; // Reset to center position
            pos_j <= 4'd4; // Reset to center position
        end else begin
            pos_i <= next_pos_i;
            pos_j <= next_pos_j;
        end
    end

    always @(*) begin
        next_pos_i = pos_i;
        next_pos_j = pos_j;

        case (current_state)
            CORRENDO_MAPA: begin
                if (up_button) begin
                    next_pos_i = (pos_i == 0) ? 4'd8 : pos_i - 1;
                end
                if (down_button) begin
                    next_pos_i = (pos_i == 8) ? 4'd0 : pos_i + 1;
                end
                if (left_button) begin
                    next_pos_j = (pos_j == 0) ? 4'd8 : pos_j - 1;
                end
                if (right_button) begin
                    next_pos_j = (pos_j == 8) ? 4'd0 : pos_j + 1;
                end
            end
        endcase
    end
endmodule