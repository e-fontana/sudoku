module controller_reader(
    input clock,
    input reset,
    input flag,
    input [5:0] controller_pins,
    output reg controller_select = 1'b1,
    output reg [11:0] controller_output
);
    localparam STATE_IDLE   = 4'd0;
    localparam STATE_ZERO   = 4'd1;
    localparam STATE_ONE    = 4'd2;
    localparam STATE_TWO    = 4'd3;
    localparam STATE_THREE  = 4'd4;
    localparam STATE_FOUR   = 4'd5;
    localparam STATE_FIVE   = 4'd6;
    localparam STATE_SIX    = 4'd7;
    localparam STATE_SEVEN  = 4'd8;

    reg up, down, left, right, a, b, c, output_x, y, output_z, start, mode = 1'b1;

    reg [3:0] state = STATE_IDLE;
    reg [11:0] counter = 0;

    always @(posedge clock) begin
        case (state)
            STATE_IDLE: begin
                counter <= 12'd0;
                controller_select <= 1'b1;
                if (flag) state <= STATE_ZERO;
            end
            STATE_ZERO: begin
                controller_select <= 1'b1;
                counter <= counter + 1;
                if (counter == 12'd1000) state <= STATE_ONE;
            end
            STATE_ONE: begin
                controller_select <= 1'b0;
                counter <= counter + 1;
                a <= ~controller_pins[4];
                start <= ~controller_pins[0];
                if (counter == 12'd2000) state <= STATE_TWO;
            end
            STATE_TWO: begin
                controller_select <= 1'b1;
                counter <= counter + 1;
                
                up <= ~controller_pins[5];
                down <= ~controller_pins[3];
                left <= ~controller_pins[2];
                right <= ~controller_pins[1];
                
                if (counter == 12'd3000) state <= STATE_THREE;
            end
            STATE_THREE: begin
                controller_select <= 1'b0;
                counter <= counter + 1;
                
                if (counter == 12'd4000) state <= STATE_FOUR;
            end
            STATE_FOUR: begin
                controller_select <= 1'b1;
                counter <= counter + 1;

                b <= ~controller_pins[4];
                c <= ~controller_pins[0];

                if (counter == 12'd5000) state <= STATE_FIVE;
            end
            STATE_FIVE: begin
                controller_select <= 1'b0;
                counter <= counter + 1;
                
                if (counter == 12'd6000) state <= STATE_SIX;
            end
            STATE_SIX: begin
                controller_select <= 1'b1;
                counter <= counter + 1;

                output_x <= ~controller_pins[2];
                y <= ~controller_pins[3];
                output_z <= ~controller_pins[5];
                mode <= ~controller_pins[1];

                if (counter == 12'd7000) state <= STATE_SEVEN;
            end
            STATE_SEVEN: begin
                controller_select <= 1'b0;
                counter <= counter + 1;

                if (counter == 12'd8000) state <= STATE_IDLE;
            end
            default: begin
                state <= STATE_IDLE;
                controller_select <= 1'b1;
                counter <= 12'd0;
            end
        endcase    
    end

    always @(negedge clock) begin
        if (!flag) controller_output <= {up, down, left, right, a, b, c, output_x, y, output_z, start};
    end

endmodule