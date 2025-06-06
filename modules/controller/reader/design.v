
module controller_reader (

    input wire clk,
    input wire reset,

    output reg  select_out,
    input wire  data_up,
    input wire  data_down,
    input wire  data_left,
    input wire  data_right,
    input wire  data_pin_ab,
    input wire  data_pin_start_c,

    output reg [7:0] leds
);

    reg btn_up, btn_down, btn_left, btn_right; // Direction
    reg btn_a, btn_b, btn_c, btn_start; // Buttons

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            select_out <= 1'b1;
            leds <= 8'b0;
            {btn_start, btn_c, btn_b, btn_a, btn_right, btn_left, btn_down, btn_up} <= 8'b0;
        end else begin
            select_out <= ~select_out;

            if (select_out) begin
                btn_b <= ~data_pin_ab;
                btn_c <= ~data_pin_start_c;
            end else begin
                btn_a     <= ~data_pin_ab;
                btn_start <= ~data_pin_start_c;
            end

            btn_up    <= ~data_up;
            btn_down  <= ~data_down;
            btn_left  <= ~data_left;
            btn_right <= ~data_right;
            leds <= {btn_start, btn_c, btn_b, btn_a, btn_right, btn_left, btn_down, btn_up};
        end
    end

endmodule