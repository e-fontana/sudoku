module map_selector(
    input clk,
    input reset,
    output [80:0] selected_visibility,
    output [323:0] selected_map
);
    wire [1214:0] all_visibilities;
    wire [4859:0] all_maps;
    wire [3:0] random_number, map_index;

    define_maps dm (
        .visibilities(all_visibilities),
        .maps(all_maps)
    );

    random r (
        .clk(clk),
        .reset(reset),
        .random_number(random_number)
    );

    assign map_index = random_number - 1;
    assign selected_visibility = all_visibilities[(map_index * 81) +: 81];
    assign selected_map = all_maps[(map_index * 324) +: 324];
endmodule
