module testbench;
    reg reset, clk, original_up_button, original_down_button, 
        original_left_button, original_right_button, original_start_button,
        original_a_button, original_b_button;
    wire error;
    wire [6:0] d0, d1, d2, d3, d4, d5, d6, d7;

    top top (
        .reset(reset),
        .clk(clk),
        .original_a_button(original_a_button),
        .original_b_button(original_b_button),
        .original_up_button(original_up_button),
        .original_down_button(original_down_button),
        .original_left_button(original_left_button),
        .original_right_button(original_right_button),
        .original_start_button(original_start_button),
        .error(error),
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3),
        .d4(d4),
        .d5(d5),
        .d6(d6),
        .d7(d7)
    );

    initial begin
        forever begin
            #10 clk = ~clk; // A cada 10 unidades de tempo, inverte o valor do clock
        end
    end

    initial begin
        reset = 1'b1;
        clk = 1'b0;

        original_up_button = 1'b1;
        original_down_button = 1'b1;
        original_left_button = 1'b1;
        original_right_button = 1'b1;
        original_start_button = 1'b0;
        original_a_button = 1'b0;
        original_b_button = 1'b0;
        #100
        original_start_button = 1'b1; // Press start button
        original_start_button = 1'b0; // Release start button
        #100
        original_a_button = 1'b1; // Press A button
        original_a_button = 1'b0; // Release A button
        #100;
    end
endmodule