module controller_reader(
    input clk,
    input reset,
    input PIN_UP_Z,      
    input PIN_DOWN_Y,      
    input PIN_LEFT_X,      
    input PIN_RIGHT_MODE,      
    input PIN_A_B,       
    input PIN_START_C,
    output reg select,      
    output wire [11:0] LEDR
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

    reg flag = 1'b1;
    reg [3:0] state = STATE_IDLE;
    reg [11:0] counter = 0;

    assign LEDR = {up, down, left, right, a, b, c, output_x, y, output_z, start, mode};

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            select <= 1'b1;
            counter <= 12'd0;
            state <= STATE_IDLE;
        end
        else begin
            case (state)
                STATE_IDLE: begin
                    counter <= 12'd0;
                    select <= 1'b1;

                    if (flag) state <= STATE_ZERO;
                    
                end
                STATE_ZERO: begin
                    select <= 1'b1;
                    counter <= counter + 12'd1;
                    if (counter == 12'd1000) state <= STATE_ONE;
                    
                end
                STATE_ONE: begin
                    select <= 1'b0;
                    counter <= counter + 12'd1;
                    a <= ~PIN_A_B;
                    start <= ~PIN_START_C;
                    if (counter == 12'd2000) state <= STATE_TWO;
                    
                end
                STATE_TWO: begin
                    select <= 1'b1;
                    counter <= counter + 12'd1;
                    
                    up <= ~PIN_UP_Z;
                    down <= ~PIN_DOWN_Y;
                    left <= ~PIN_LEFT_X;
                    right <= ~PIN_RIGHT_MODE;
                    
                    if (counter == 12'd3000) state <= STATE_THREE;
                    
                end
                STATE_THREE: begin
                    select <= 1'b0;
                    counter <= counter + 12'd1;
                    
                    if (counter == 12'd4000) state <= STATE_FOUR;
                end
                STATE_FOUR: begin
                    select <= 1'b1;
                    counter <= counter + 12'd1;

                    b <= ~PIN_A_B;
                    c <= ~PIN_START_C;

                    if (counter == 12'd5000) state <= STATE_FIVE;
                end
                STATE_FIVE: begin
                    select <= 1'b0;
                    counter <= counter + 12'd1;
                    
                    if (counter == 12'd6000) state <= STATE_SIX;
                end
                STATE_SIX: begin
                    select <= 1'b1;
                    counter <= counter + 12'd1;

                    output_x <= ~PIN_LEFT_X;
                    y <= ~PIN_DOWN_Y;
                    output_z <= ~PIN_UP_Z;
                    mode <= ~PIN_RIGHT_MODE;

                    if (counter == 12'd7000) state <= STATE_SEVEN;
                end
                STATE_SEVEN: begin
                    select <= 1'b0;
                    counter <= counter + 12'd1;

                    if (counter == 12'd8000) state <= STATE_IDLE;
                end
                default: begin
                    state <= STATE_IDLE;
                    select <= 1'b1;
                    counter <= 12'd0;
                end
            endcase    
        end
        
    end
endmodule