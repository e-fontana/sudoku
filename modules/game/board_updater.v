module board_updater #(
    parameter CARREGANDO = 3'b010,
    parameter PERCORRER_NUMEROS = 3'b100
) (
    input clk,
    input reset,
    
    input left_button,
    input right_button,
    input a_button,
    input b_button,

    input [7:0] index,
    input [3:0] cell_value,

    input [2:0] current_state,

    input [161:0] selected_visibility,
    input [323:0] selected_map,
    output reg [161:0] visibilities,
    output reg [323:0] board,

    output reg error,
    output reg [1:0] strikes,
    output reg [3:0] selected_number
);
    reg next_error;
    reg [1:0] next_strikes;
    reg [323:0] next_board;
    reg [161:0] next_visibilities;
    reg [3:0] next_selected_number;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            error <= 1'b0;
            strikes <= 2'b00;
            selected_number <= 4'd1;
            visibilities <= 162'b0;
            board <= 324'b0;
        end else begin
            error <= next_error;
            board <= next_board;
            strikes <= next_strikes;
            selected_number <= next_selected_number;
            visibilities <= next_visibilities;
        end
    end

    always @(*) begin
        next_error = error;
        next_strikes = strikes;
        next_visibilities = visibilities;
        next_board = board;
        next_error = error;
        next_selected_number = selected_number;

        case (current_state)
            CARREGANDO: begin
                next_visibilities = selected_visibility;
                next_board = selected_map;
            end
            PERCORRER_NUMEROS: begin
                if (~error) begin
                    next_visibilities[index +: 2] = 2'b01;
                end

                if (b_button) begin
                    next_error = 1'b0;
                    next_visibilities[index +: 2] = 2'b00;
                end

                if (left_button | right_button) begin
                    next_error = 1'b0;
                    next_visibilities[index +: 2] = 2'b01;
                end
                
                if (right_button) begin
                    if (selected_number < 9) begin
                        next_selected_number = selected_number + 4'd1;
                    end else begin
                        next_selected_number = 4'd1;
                    end
                end else if (left_button) begin
                    if (selected_number > 1) begin
                        next_selected_number = selected_number - 4'd1;
                    end else begin
                        next_selected_number = 4'd9;
                    end
                end

                if (a_button) begin
                    if (cell_value == selected_number) begin
                        next_visibilities[index +: 2] = 2'b11; // Mark the cell as correctly visited
                    end else begin
                        next_error = 1'b1;
                        next_visibilities[index +: 2] = 2'b10; // Mark the cell as visited with error

                        if (strikes < 2'b11) begin
                            next_strikes = strikes + 2'd1;
                        end
                    end
                end
            end
        endcase
    end
endmodule