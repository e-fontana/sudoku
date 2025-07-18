module map_selector (
    input clk,
    input reset,
    input difficulty,
    output reg [161:0] selected_visibility,
    output reg [323:0] selected_map
);
    // Wires para receber os dados de todos os mapas
    wire [161:0] visibilities_easy, visibilities_hard;
    wire [323:0] maps_easy, maps_hard;

    // Wire para receber o índice (0-7) do nosso novo gerador
    wire [2:0] map_index;

    define_maps dm (
        .visibilities_easy(visibilities_easy),
        .visibilities_hard(visibilities_hard),
        .maps_easy(maps_easy),
        .maps_hard(maps_hard)
    );

    // Instanciando o novo gerador de índice
    random r (
        .clk(clk),
        .reset(reset),
        .random_number(map_index) // Conecta a saída do gerador ao nosso wire
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            selected_visibility <= 162'd0;
            selected_map        <= 324'd0;
        end else begin
            if (difficulty) begin
                selected_visibility <= visibilities_hard;
                selected_map        <= maps_hard;
            end else begin
                selected_visibility <= visibilities_easy;
                selected_map        <= maps_easy;
            end
        end
    end
endmodule
