module map_selector (
    input clk,
    input reset,
    output [404:0] selected_map
);
    wire [6074:0] maps;
    wire [3:0] random_number, map_index;

    define_maps dm (
        .maps(maps)
    );

    random r (
        .clk(clk),
        .reset(reset),
        .random_number(random_number)
    );

    assign map_index = random_number - 1;
    assign selected_map = maps[(map_index * 405) +: 405];
endmodule
