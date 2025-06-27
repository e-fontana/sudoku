module controller_reader(
    input clock,
    input reset,
    input flag,
    input [5:0] controller_pins,
    output controller_select,
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

    reg up, down, left, right, a, b, c, output_x, y, output_z, start, mode = 1'b0;

    reg select_output = 1'b1;
    reg [3:0] state = STATE_IDLE;
    reg [11:0] counter = 0;
    reg [11:0] led_reg = 0;

    always @(negedge clock) begin
        if (!flag) begin
            controller_output <= {up, down, left, right, a, b, c, output_x, y, output_z, start};
        end
    end

    assign controller_select = select_output;

    wire PIN_UP_Z = controller_pins[5];
    wire PIN_DOWN_Y = controller_pins[3];
    wire PIN_LEFT_X = controller_pins[2];
    wire PIN_RIGHT_MODE = controller_pins[1];
    wire PIN_A_B = controller_pins[4];
    wire PIN_START_C = controller_pins[0];

    always @(posedge clock or negedge reset) begin
        if (!reset) begin
            select_output <= 1'b1;
            counter <= 12'd0;
            state <= STATE_IDLE;
        end
        else begin
            case (state)
                STATE_IDLE: begin
                    counter <= 12'd0;
                    select_output <= 1'b1;

                    if (flag) state <= STATE_ZERO;
                    
                end
                STATE_ZERO: begin
                    select_output <= 1'b1;
                    counter <= counter + 12'd1;
                    if (counter == 12'd1000) state <= STATE_ONE;
                    
                end
                STATE_ONE: begin
                    select_output <= 1'b0;
                    counter <= counter + 12'd1;
                    a <= ~PIN_A_B;
                    start <= ~PIN_START_C;
                    if (counter == 12'd2000) state <= STATE_TWO;
                    
                end
                STATE_TWO: begin
                    select_output <= 1'b1;
                    counter <= counter + 12'd1;
                    
                    up <= ~PIN_UP_Z;
                    down <= ~PIN_DOWN_Y;
                    left <= ~PIN_LEFT_X;
                    right <= ~PIN_RIGHT_MODE;
                    
                    if (counter == 12'd3000) state <= STATE_THREE;
                    
                end
                STATE_THREE: begin
                    select_output <= 1'b0;
                    counter <= counter + 12'd1;
                    
                    if (counter == 12'd4000) state <= STATE_FOUR;
                end
                STATE_FOUR: begin
                    select_output <= 1'b1;
                    counter <= counter + 12'd1;

                    b <= ~PIN_A_B;
                    c <= ~PIN_START_C;

                    if (counter == 12'd5000) state <= STATE_FIVE;
                end
                STATE_FIVE: begin
                    select_output <= 1'b0;
                    counter <= counter + 12'd1;
                    
                    if (counter == 12'd6000) state <= STATE_SIX;
                end
                STATE_SIX: begin
                    select_output <= 1'b1;
                    counter <= counter + 12'd1;

                    output_x <= ~PIN_LEFT_X;
                    y <= ~PIN_DOWN_Y;
                    output_z <= ~PIN_UP_Z;
                    mode <= ~PIN_RIGHT_MODE;

                    if (counter == 12'd7000) state <= STATE_SEVEN;
                end
                STATE_SEVEN: begin
                    select_output <= 1'b0;
                    counter <= counter + 12'd1;

                    if (counter == 12'd8000) state <= STATE_IDLE;
                end
                default: begin
                    state <= STATE_IDLE;
                    select_output <= 1'b1;
                    counter <= 12'd0;
                end
            endcase    
        end
        
    end
endmodule