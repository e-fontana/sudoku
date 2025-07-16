module SendGameDificulty  #(parameter EVENT_CODE = 8'hAB) (
    input wire clk,
    input wire reset,
    input wire start,
    input wire tx_busy,
    input wire tx_start,
    input wire dificuldade,    

    output reg [7:0] tx_data,
    output reg data_sent
);

    localparam IDLE             = 2'b00;
    localparam BUILDING_PAYLOAD = 2'b01;
    localparam SENDING_DATA     = 2'b10;
    localparam DATA_SENT_STATE  = 2'b11;

    wire [7:0] payload = { 7'b0000000, nivel_dificuldade };

    reg [1:0] state;
    reg [1:0] byte_index;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            data_sent <= 0;
            tx_data <= 8'd0;
            byte_index <= 0;
        end else begin
            case (state)
                IDLE: begin
                    data_sent <= 0;
                    if (data_valid) begin
                        state <= BUILDING_PAYLOAD;
                    end
                end

                BUILDING_PAYLOAD: begin
                    build_payload <= 1;
                    if (tx_start) begin
                        byte_index <= 0;
                        state <= SENDING_DATA;
                    end
                end

                SENDING_DATA: begin
                    if (!tx_busy) begin
                        case (byte_index)
                            0: tx_data <= EVENT_CODE;
                            1: tx_data <= payload;
                        endcase
                        byte_index <= byte_index + 1;
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