module map_selector (
    input clk,
    input reset,
    output [161:0] selected_visibility,
    output [323:0] selected_map
);
    wire [2429:0] visibilities;
    wire [4859:0] maps;
    wire [3:0] random_number, map_index;

    define_maps dm (
        .visibilities(visibilities),
        .maps(maps)
    );

    random r (
        .clk(clk),
        .reset(reset),
        .random_number(random_number)
    );

    assign map_index = random_number - 4'd1;
    assign selected_visibility = visibilities[(map_index * 162) +: 162];
    assign selected_map = maps[(map_index * 324) +: 324];
endmodule
