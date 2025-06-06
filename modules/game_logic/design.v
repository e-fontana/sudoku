module sudoku_fsm (
    input wire clk,
    input wire reset,
    input wire start_button,
    input wire a_button,
    input wire b_button,      
    input wire up_button,
    input wire down_button,
    input wire left_button,
    input wire right_button,
    
    output reg [2:0] current_state,
    output reg title_display,
    output reg difficulty_display,
    output reg running_display,
    output reg easy_selected,
    output reg hard_selected,
    output reg [3:0] cursor_x, 
  output reg [3:0] cursor_y,
  output reg [3:0] cell_value [0:8][0:8],
  output reg [3:0] selected_number,
  output reg win
);


parameter [2:0] 
   Q0_INICIAR_JOGO        		 = 3'b000,
   Q1_SELECIONAR_DIFICULDADE 	 = 3'b001,
   CARREGANDO             		 = 3'b010,
   CORRENDO_MAPA          		 = 3'b011,
   PERCORRER_NUMEROS        	 = 3'b100,
   VITORIA 						 = 3'b101,
   BAHIA						 = 3'b110;


  reg [6:0] filled_cells; 
  reg [1:0] difficulty_option; // 01=fácil, 10=difícil
  reg [3:0] temp_number;  // Número temporário durante seleção


always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= Q0_INICIAR_JOGO;
        difficulty_option <= 2'b01; // Modo fácil marretado
        cursor_x <= 4'd4;          
        cursor_y <= 4'd4;
        selected_number <= 4'd0;
        temp_number <= 4'd0;
    end else begin
        case (current_state)
            Q0_INICIAR_JOGO: begin
                if (start_button) begin
                    current_state <= Q1_SELECIONAR_DIFICULDADE;
                end
            end
            
            Q1_SELECIONAR_DIFICULDADE: begin
               
                if (up_button) begin
                    difficulty_option <= 2'b01; 
                end else if (down_button) begin
                    difficulty_option <= 2'b10;
                end
                
               
                if (a_button) begin
                    current_state <= CORRENDO_MAPA;
                end
            end
            
//             CARREGANDO: begin
                
//                 #100;  //** delay dentro de bloco Gera problema de sintetizacao .
//                 current_state <= CORRENDO_MAPA;
//             end
            
            CORRENDO_MAPA: begin
                
                if (up_button && cursor_y > 0) begin
                    cursor_y <= cursor_y - 1;
                end
                if (down_button && cursor_y < 8) begin
                    cursor_y <= cursor_y + 1;
                end
                if (left_button && cursor_x > 0) begin
                    cursor_x <= cursor_x - 1;
                end
                if (right_button && cursor_x < 8) begin
                    cursor_x <= cursor_x + 1;
                end
              
             	
              if (a_button) begin
                    current_state <= PERCORRER_NUMEROS;
                   // temp_number <= selected_number; 
                end
              
              
              /// Forçar vitoria por enquanto
               if (b_button) begin
                    current_state <= VITORIA;
                end
              
              
                
                

            end
          
          
           PERCORRER_NUMEROS: begin
               
                if (up_button) begin
                    if (temp_number < 9) temp_number <= temp_number + 1;
                    else temp_number <= 4'd0;  
                end
                else if (down_button) begin
                    if (temp_number > 0) temp_number <= temp_number - 1;
                    else temp_number <= 4'd9;  
                end
                
               if (a_button) begin
                  cell_value[cursor_x][cursor_y] <= temp_number;
                    current_state <= CORRENDO_MAPA;
                    temp_number <= selected_number;  // Carrega número atual
                end
              
                
                // Cancelamento com B
                if (b_button) begin
                    current_state <= CORRENDO_MAPA;
                end
            end
          
            VITORIA: begin
                
               
              
              if (start_button) begin
                    current_state <= Q1_SELECIONAR_DIFICULDADE;
                end
              
              
                
                

            end
        endcase
    end
end


// always @(*) begin
//     // Reset de todas as saídas
//     title_display = 1'b0;
//     difficulty_display = 1'b0;
//     running_display = 1'b0;
//     easy_selected = 1'b0;
//     hard_selected = 1'b0;
    
//     case (current_state)
//         Q0_INICIAR_JOGO: begin
//             title_display = 1'b1;
//         end
        
//         Q1_SELECIONAR_DIFICULDADE: begin
//             difficulty_display = 1'b1;
//             easy_selected = (difficulty_option == 2'b01);
//             hard_selected = (difficulty_option == 2'b10);
//         end
        
//         CARREGANDO: begin
//             // Display de carregamento pode ser adicionado aqui
//         end
        
//         CORRENDO_MAPA: begin
//             running_display = 1'b1;
//         end
//     endcase
// end

endmodule