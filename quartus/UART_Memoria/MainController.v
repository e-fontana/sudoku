module MainController #(
    parameter INICIAR_JOGO = 3'b000,
    parameter SELECIONAR_DIFICULDADE = 3'b001,
    parameter CARREGANDO = 3'b010,
    parameter CORRENDO_MAPA = 3'b011,
    parameter PERCORRENDO_NUMEROS = 3'b100,
    parameter VITORIA = 3'b101,
    parameter DERROTA = 3'b110
) (
    input clock,
    input reset,
    
    input [2:0] current_state,

    // start game
    input game_started,
    
    // game dificulty
    input game_dificulty,
    
    // board
    input [323:0] full_board,

    // status
    input [161:0] colors,
    input [3:0] position_x,
    input [3:0] position_y,
    input [1:0] errors,
    input [3:0] selected_number,

    // end_game
    input victory_condition,
    input [6:0] score,
    input [10:0] time_in_seconds,

    output [7:0] tx_data
);
    reg tx_start;
endmodule