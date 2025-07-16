module SendGameDificulty  #(parameter EVENT_CODE = 8'hAB) (
    input wire clk,
    input wire reset,
    input wire data_valid,
    input wire block,
    input wire tx_busy,
    input wire payload_ready,
    input wire data_sent,
    input wire [7:0] nivel_dificuldade,    

    output reg [7:0] tx_data,
    output reg send,
    output reg build_payload,
    output reg fim_envio
);

    localparam IDLE             = 2'b00;
    localparam BUILDING_PAYLOAD = 2'b01;
    localparam SENDING_DATA     = 2'b10;

    reg [1:0] state;
    reg [1:0] byte_index;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            send <= 0;
            build_payload <= 0;
            fim_envio <= 0;
            tx_data <= 8'd0;
            byte_index <= 0;
        end else begin
            send <= 0;
            build_payload <= 0;

            case (state)
                IDLE: begin
                    fim_envio <= 0;
                    if (data_valid && !block && EVENT_CODE == 8'hAB) begin
                        build_payload <= 1;
                        state <= BUILDING_PAYLOAD;
                    end
                end

                BUILDING_PAYLOAD: begin
                    build_payload <= 1;
                    if (payload_ready) begin
                        byte_index <= 0;
                        state <= SENDING_DATA;
                    end
                end

                SENDING_DATA: begin
                    if (!tx_busy) begin
                        send <= 1;
                        case (byte_index)
                            0: tx_data <= EVENT_CODE;
                            1: tx_data <= nivel_dificuldade;
                        endcase
                        byte_index <= byte_index + 1;
                    end
						  
                    if (byte_index == 2 && data_sent && !tx_busy) begin
                        fim_envio <= 1;
                        state <= IDLE;
                        byte_index <= 0;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule