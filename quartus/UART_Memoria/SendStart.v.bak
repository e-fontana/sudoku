module SendStart #(parameter EVENT_CODE = 8'hAA) (
    input wire clk,
    input wire reset,
    input wire start,            
    input wire block,

    input wire tx_busy,
    input wire payload_ready,
    input wire data_sent,

    output reg [7:0] tx_data,
    output reg send,
    output reg build_payload
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
            byte_index <= 0;
        end else begin
            send <= 0;
            build_payload <= 0;

            case (state)
                IDLE: begin
                    if (start && !block) begin
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
                            tx_data <= EVENT_CODE;
                            byte_index <= 1;
                        end else if (byte_index == 1) begin
                            tx_data <= 8'h01;
                            byte_index <= 2;
                        end
                    end

                    if (byte_index == 2 && data_sent && !tx_busy) begin
                        state <= IDLE;
                        byte_index <= 0;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule