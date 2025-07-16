module SendStartGame #(parameter EVENT_CODE = 8'hAA) (
    input  wire         clock,
    input  wire         reset,
    input  wire         habilitar_envio,
    input  wire         uart_ocupado,

    output		         iniciar_envio,
    output [7:0]   dado_saida,
    output         envio_concluido
);
	wire [7:0] payload = 8'd0;

    PayloadController #(
        .EVENT_CODE(EVENT_CODE),
        .SEND_BYTES_QTD(0)
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
