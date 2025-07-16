module SendStartGame #(parameter EVENT_CODE = 8'hAA) (
    input wire clk,
    input wire reset,
    input wire start,     
    input wire game_stated,
    input wire tx_busy,
    input wire tx_start,
    
    output reg [7:0] tx_data,
    output reg data_sent
);
    localparam IDLE             = 2'b00;
    localparam BUILDING_PAYLOAD = 2'b01;
    localparam SENDING_DATA     = 2'b10;
    localparam DATA_SENT_STATE  = 2'b11;

    reg [1:0] state;
    reg [1:0] byte_index;

    wire [7:0] payload = { 7'b0000000, game_stated };

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            tx_data <= 8'd0;
            send <= 0;
            byte_index <= 0;
            data_sent <= 0;
        end else begin
            data_sent <= 0;
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= BUILDING_PAYLOAD;
                    end
                end

                BUILDING_PAYLOAD: begin
                    if (tx_start) begin
                        byte_index <= 0;
                        state <= SENDING_DATA;
                    end
                end

                SENDING_DATA: begin
                    if (!tx_busy) begin
                        if (byte_index == 0) begin
                            tx_data <= EVENT_CODE;
                            byte_index <= 1;
                        end else if (byte_index == 1) begin
                            tx_data <= payload;
                            byte_index <= 2;
                        end
                    end
                    if (byte_index == 2 && !tx_busy)
                        state <= DATA_SENT_STATE;
                end

                DATA_SENT_STATE: begin
                    data_sent <= 1;
                    state <= IDLE;
                    byte_index <= 0;
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule
