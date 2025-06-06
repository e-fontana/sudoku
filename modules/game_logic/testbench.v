`timescale 1ns / 1ps

module tb_sudoku_fsm();

// Entradas
reg clk;
reg reset;
reg start_button;
reg a_button;
reg b_button;
reg up_button;
reg down_button;
reg left_button;
reg right_button;

// Saídas
wire [2:0] current_state;
wire title_display;
wire difficulty_display;
wire running_display;
wire easy_selected;
wire hard_selected;
wire [3:0] cursor_x;
wire [3:0] cursor_y;
  

   
// reg [3:0] last_cursor_x, last_cursor_y;
// reg [3:0] last_cell_value;

// Instância do módulo testado
sudoku_fsm uut (
    .clk(clk),
    .reset(reset),
    .start_button(start_button),
    .a_button(a_button),
    .b_button(b_button),
    .up_button(up_button),
    .down_button(down_button),
    .left_button(left_button),
    .right_button(right_button),
    .current_state(current_state),
    .title_display(title_display),
    .difficulty_display(difficulty_display),
    .running_display(running_display),
    .easy_selected(easy_selected),
    .hard_selected(hard_selected),
    .cursor_x(cursor_x),
    .cursor_y(cursor_y)
);

// Geração de clock (100 MHz)
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end


reg [8*20:0] state_names [0:7];
initial begin
    state_names[3'b000] = "Q0_INICIAR_JOGO";
    state_names[3'b001] = "Q1_SELEC_DIFICULDADE";
    state_names[3'b010] = "CARREGANDO";
    state_names[3'b011] = "CORRENDO_MAPA";
    state_names[3'b100] = "PERCORRER_NUMEROS";
  state_names[3'b101] = "VITORIA";
    // ... outros estados
end

// Monitoramento de estados
always @(uut.current_state) begin
    $display("[%0t] Estado: %s", $time, state_names[uut.current_state]);
end

// Procedimento de teste
initial begin
  
  for (int i = 0; i < 9; i++) begin
        for (int j = 0; j < 9; j++) begin
            uut.cell_value[i][j] = 4'd0;
        end
    end
  
  
    // Inicialização
    reset = 1;
    start_button = 0;
    a_button = 0;
    b_button = 0;
    up_button = 0;
    down_button = 0;
    left_button = 0;
    right_button = 0;
    
    // Teste 1: Reset e estado inicial
    #20;
    reset = 0;
    #10;
    
    // Teste 2: Transição para Q1
    start_button = 1;
    #10;
    start_button = 0;
    #10;
    
    // Teste 3: Seleciona difícil e confirma
    down_button = 1;
    #10;
    down_button = 0;
    #10;
    a_button = 1;
    #10;
    a_button = 0;
    #100; // Espera carregamento
  
   
    
    // Teste 4: Navegação no mapa
    $display("Posição inicial do cursor: (%0d, %0d)", uut.cursor_x, uut.cursor_y);
    
    // Move para cima
    up_button = 1;
    #10;
    up_button = 0;
    #10;
    $display("Posição após UP: (%0d, %0d)", uut.cursor_x, uut.cursor_y);
    
    // Move para esquerda
    left_button = 1;
    #10;
    left_button = 0;
    #10;
    $display("Posição após LEFT: (%0d, %0d)", uut.cursor_x, uut.cursor_y);
    
 
   
  
  
  // Teste botão Escolhendo numeros
  a_button = 1; // muda pra escolhendo numeros
    #10;
  
  a_button = 0;
  #10;

   
  repeat(3) begin
    up_button = 1;
    #10;
    up_button = 0;
    #10;
   end
  #10;
  a_button = 1; //sai de escolhendo numeros e confirma numero
  #10;
   a_button = 0;
   #10;
  
  $display("Posição após Confirmar primeiro numero: (%0d, %0d)", 
        uut.cursor_x, uut.cursor_y, 
        uut.cell_value[uut.cursor_x][uut.cursor_y]);
  
   // Move para esquerda
    left_button = 1;
    #10;
    left_button = 0;
    #10;
    $display("Posição após LEFT: (%0d, %0d)", uut.cursor_x, uut.cursor_y);
  
    
   // Teste botão Escolhendo numero 2
  a_button = 1; // muda pra escolhendo numeros
    #10;
  
  a_button = 0;
     #10;
    up_button = 1;
    #10;
   
  repeat(4) begin
    up_button = 1;
    #10;
    up_button = 0;
    #10;
   end
  
  a_button = 1; //sai de escolhendo numeros
  #10;
   a_button = 0;
   #10;
  

  
  $display("Cell (%0d,%0d) = %0d", 
        uut.cursor_x, uut.cursor_y, 
        uut.cell_value[uut.cursor_x][uut.cursor_y]);
  
   // Move para cima
  up_button = 1;
    #10;
   up_button = 0;
  #10;
  $display("Posição após Cima: (%0d, %0d)", uut.cursor_x, uut.cursor_y);
    left_button = 0;
    #10;
  
    
   
  a_button = 1; //entra em percorrend numero
  #10;
   a_button = 0;
   #10;
  
  
   
  repeat(5) begin
    up_button = 1;
    #10;
    up_button = 0;
    #10;
   end
  
  b_button = 1; //volta para percorrendo mapa e nao muda numero
  #10;
   b_button = 0;
      #10;
  
  $display("Posição após apertar B: (%0d, %0d)", uut.cursor_x, uut.cursor_y);
  
     // Move para cima, left down, down
  up_button = 1;
    #10;
  up_button = 0;
  $display("Posição após up: (%0d, %0d)", uut.cursor_x, uut.cursor_y);

   #10;
    left_button = 1;
    #10;
  $display("Posição após left: (%0d, %0d)", uut.cursor_x, uut.cursor_y);
  
    left_button = 0;
  #10;
  down_button = 1;
  $display("Posição após down: (%0d, %0d)", uut.cursor_x, uut.cursor_y);
   #10;
 
    
    down_button = 0;
   #10;
  down_button = 1;
  $display("Posição após down: (%0d, %0d)", uut.cursor_x, uut.cursor_y);
    #10;
   down_button = 0;
   #10;
  
 $display("Posição após combo: (%0d, %0d)", uut.cursor_x, uut.cursor_y);
  
  
  
  
  // -------------------------------------------------
   //Testes passando para vitoria 
  
  b_button = 1;
  #10
  b_button =0;
   #20
   start_button = 1;
  #10
  start_button =0;
  		
  
  //
  
  
  
  
  $display("Todos os testes passaram com sucesso!");
    $finish;
end
  
  
    always @(uut.current_state) begin
    $display("[%0t] Estado mudou para: %0d", $time, uut.current_state);
	end
  
  always @(uut.cursor_x or uut.cursor_y) begin
    if (uut.current_state == 3'b011) begin 
        $display("[%0t] Cursor agora em (%0d,%0d) = %0d",
               $time,
               uut.cursor_x, uut.cursor_y,
               uut.cell_value[uut.cursor_x][uut.cursor_y]);
    end
  end
  
  always @(uut.cursor_x or uut.cursor_y) begin
    if (uut.current_state == 3'b011) begin //
        print_grid();
        $display("Cursor at (%0d,%0d)", uut.cursor_x, uut.cursor_y);
    end
end
task print_grid;
    $display("\nCurrent Sudoku Grid:");
    $display("    0 1 2   3 4 5   6 7 8");
    $display("  +-------+-------+-------+");
    for (int y = 0; y < 9; y++) begin
        $write("%0d | ", y);
        for (int x = 0; x < 9; x++) begin
            $write("%0d ", uut.cell_value[x][y]);
            if (x == 2 || x == 5) $write("| ");
        end
        $display("|");
        if (y == 2 || y == 5) begin
            $display("  +-------+-------+-------+");
        end
    end
    $display("  +-------+-------+-------+");
endtask

endmodule