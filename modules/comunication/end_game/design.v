module SendEndGame #(parameter EVENT_CODE = 8'hAE) (
    input wire clk,
    input wire reset,
    input wire block,
    input wire data_valid,
    input wire tx_busy,
    
    input wire data_sent,
    input wire payload_ready,
    input wire [4:0] pontuacao,

    output reg [7:0] tx_data,
    output reg send,
    output reg build_payload,
    output reg fim_jogo,
    output reg vitoria
);
    localparam IDLE             = 2'b00;
    localparam BUILDING_PAYLOAD = 2'b01;
    localparam SENDING_DATA     = 2'b10;

    reg [1:0] state;
    reg [1:0] byte_index;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            tx_data <= 8'd0;
            send <= 0;
            build_payload <= 0;
            fim_jogo <= 0;
            vitoria <= 0;
            byte_index <= 0;
        end else begin
            send <= 0;
            build_payload <= 0;

            case (state)
                IDLE: begin
                    fim_jogo <= 0;
                    if (data_valid && !block && evento == 8'hAB) begin
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

                        if (byte_index == 0) begin
                            tx_data <= EVENT_CODE; // Envia evento de end game
                            byte_index <= 1;
                        end else if (byte_index == 1) begin
                            if (pontuacao >= 5'd20) begin // 100 decimal
                                tx_data <= 8'h10; // Vitória
                                vitoria <= 1;
                            end else begin
                                tx_data <= 8'h00; // Derrota
                                vitoria <= 0;
                            end
                            byte_index <= 2;
                        end
                    end

                    if (byte_index == 2 && data_sent && !tx_busy) begin
                        fim_jogo <= 1;
                        state <= IDLE;
                        byte_index <= 0;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule