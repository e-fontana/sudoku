module SendGameDificulty #(parameter EVENT_CODE = 8'hAB) (
    input  wire         clock,
    input  wire         reset,
    input  wire         habilitar_envio,
    input  wire         uart_ocupado,
    input  wire [323:0] game_dificulty,

    output reg         iniciar_envio,
    output reg [7:0]   dado_saida,
    output wire         envio_concluido
);
    wire [7:0] payload = { 7'b0000000, game_dificulty };

    PayloadController #(
        .EVENT_CODE(EVENT_CODE),
        .SEND_BYTES_QTD(1)
    ) payload_controller (
        .clock(clk),
        .reset(reset),
        .habilitar_envio(habilitar_envio),
        .uart_ocupado(uart_ocupado),

        .buffer_envio(payload),

        .iniciar_envio(iniciar_envio),
        .dado_saida(dado_saida),
        .envio_concluido(envio_concluido)
    );    
endmodule
