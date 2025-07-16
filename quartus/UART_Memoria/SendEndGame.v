module SendEndGame #(parameter EVENT_CODE = 8'hAE) (
    input  wire         clock,
    input  wire         reset,
    input  wire         habilitar_envio,
    input  wire         uart_ocupado,
    input  wire [6:0]   points,
    input  wire         victory_condition,

    output wire         iniciar_envio,
    output wire [7:0]   dado_saida,
    output wire         envio_concluido
);
    wire [7:0] payload = {victory_condition, points};

    PayloadController #(
        .EVENT_CODE(EVENT_CODE),
        .SEND_BYTES_QTD(1)
    ) payload_controller (
        .clock(clock),
        .reset(reset),
        .habilitar_envio(habilitar_envio),
        .uart_ocupado(uart_ocupado),

        .buffer_envio(payload),

        .iniciar_envio(iniciar_envio),
        .dado_saida(dado_saida),
        .envio_concluido(envio_concluido)
    );    
endmodule