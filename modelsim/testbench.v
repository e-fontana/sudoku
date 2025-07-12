module testbench;
    reg clk;
    reg reset;
    reg original_up_button, original_down_button, 
        original_left_button, original_right_button;
    reg a_button, b_button, start_button;
    wire error;
    wire [6:0] d0, d1, d2, d3,
               d4, d5, d6, d7;
    
    wire [3:0] sudoku_matrix [8:0][8:0];

    genvar i, j;
    generate
        for (i = 0; i < 9; i = i + 1) begin: ROW
            for (j = 0; j < 9; j = j + 1) begin: COL
                localparam index = (i * 9 + j) * 4;
                assign sudoku_matrix[i][j] = linear_map[index +: 4];
            end
        end
    endgenerate

    top top(
        // clock and reset
        reset,
        clk,
        // buttons
        a_button,
        b_button,
        original_up_button,
        original_down_button,
        original_left_button,
        original_right_button,
        start_button,
        // outputs
        error,
        d0, d1, d2, d3, d4, d5, d6, d7
    );

    initial begin
        forever begin
            clk = ~clk;
            #5;
        end
    end

    initial begin
        clk = 1'b0;
        reset = 1'b1;
        #15 reset = 1'b0;
        #1000;
        start_button = 1'b1;
        #5 start_button = 1'b0;
        #1000;
        a_button = 1'b1;
        #5 a_button = 1'b0;
        #1000;
    end
endmodule