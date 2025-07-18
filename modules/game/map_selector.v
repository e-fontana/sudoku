module map_selector (
    input clk,
    input reset,
    input difficulty,
    output reg [161:0] selected_visibility,
    output reg [323:0] selected_map
);
    // Wires para receber os dados de todos os mapas
    wire [2429:0] visibilities_easy, visibilities_hard;
    wire [4859:0] maps_easy, maps_hard;

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
            selected_map        <= 162'd0;
        end else begin
            if (difficulty) begin
                selected_visibility <= visibilities_hard[(map_index * 162) +: 162];
                selected_map        <= maps_hard[(map_index * 324) +: 324];
            end else begin
                selected_visibility <= visibilities_easy[(map_index * 162) +: 162];
                selected_map        <= maps_easy[(map_index * 324) +: 324];
            end
        end
    end
endmodule
