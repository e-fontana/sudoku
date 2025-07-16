module SendFullMap #(
    parameter [7:0] EVENTO_CODE = 8'hAC
)(
    input  wire         clock,
    input  wire         reset,
    input  wire         habilitar_envio,
    input  wire         uart_ocupado,
    input  wire [323:0] full_map_input, // 324 bits (40.5 bytes)

    output wire         iniciar_envio,
    output wire [7:0]   dado_saida,
    output wire         envio_concluido
);

    localparam MAP_SIZE_BYTES = 42;
    localparam MAP_SIZE_BITS  = MAP_SIZE_BYTES * 8;

    wire [MAP_SIZE_BITS-1:0] payload_data;

    assign payload_data = { {(MAP_SIZE_BITS-324){1'b0}}, full_map_input };

    PayloadController #(
        .EVENTO_CODE(EVENTO_CODE)
    ) send_generic (
        .clock(clock),
        .reset(reset),
        .habilitar_envio(habilitar_envio),
        .uart_ocupado(uart_ocupado),
        .quantidade_bytes(MAP_SIZE_BYTES),
        .payload_data(payload_data),
        .iniciar_envio(iniciar_envio),
        .dado_saida(dado_saida),
        .envio_concluido(envio_concluido)
    );

endmodule
