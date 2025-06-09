/**
 * @module controller_emulator_fixed
 * @brief Emula um controle de 3/6 botões (sem X,Y,Z) com a lógica de estados corrigida.
 */
module controller_reader (
    input clk,
    input p7,     // DB9_PIN7 (SEL)
    output [5:0] leds, // {DB9_PIN1, DB9_PIN2, DB9_PIN3, DB9_PIN4, DB9_PIN6, DB9_PIN9}
    input up,     // Up button (1 when not pressed, 0 when pressed)
    input dw,     // Down button
    input lf,     // Left button
    input rg,     // Right button
    input a,      // A button
    input b,      // B button
    input c,      // C button
    input st      // Start button
);

    // --- Parâmetros e Estados ---
    parameter TIMEOUT = 14'd8000;
    
    // MUDANÇA 1: Usar `localparam` para dar nomes aos estados torna o código muito mais fácil de ler.
    localparam STATE_AS   = 2'b00; // Estado para ler A e Start
    localparam STATE_BC   = 2'b01; // Estado para ler B e C
    localparam STATE_HI_Z_1 = 2'b10; // Estado para a 3ª leitura (normalmente X,Y,Z, mas aqui sem resposta)
    localparam STATE_HI_Z_2 = 2'b11; // Estado para a 4ª leitura (sem resposta)

    // --- Registradores ---
    reg [13:0] clk_counter = TIMEOUT;
    reg [1:0]  hi_count    = STATE_AS; // Renomear para 'state' seria ideal, mas mantendo o original.
    reg [5:0]  p           = 6'b111111;
    assign     leds        = p;

    // MUDANÇA 2: Simplificação do detector de borda. Só precisamos de um registrador de atraso.
    reg last_p7 = 1'b0;

    // --- Lógica da Máquina de Estados ---
    always @(posedge clk) begin
        // Atualiza o valor anterior de p7 a cada ciclo
        last_p7 <= p7;

        // MUDANÇA 3: Detector de borda de subida (L->H) simples e confiável.
        // Isso dispara quando 'p7' está em 1 AGORA e estava em 0 no ciclo anterior.
        if (p7 && !last_p7) begin
            hi_count <= hi_count + 1; // Incrementa o estado
            clk_counter <= TIMEOUT;   // Reseta o contador de timeout
        end else begin
            // Se não houver borda de subida, o timeout continua contando
            if (clk_counter == 0) begin
                clk_counter <= TIMEOUT;
                hi_count <= STATE_AS; // Se o console parar de perguntar, volta ao estado inicial
            end else begin
                clk_counter <= clk_counter - 1;
            end
        end
    end

    // --- Lógica de Saída ---
    always @(*) begin
        // MUDANÇA 4: Bloco 'case' corrigido, sem itens duplicados e com lógica clara.
        case (hi_count)
            // 1ª Leitura (select=HIGH): Responde com Cima, Baixo, A, Start.
            STATE_AS:   p = {up, dw, 1'b1, 1'b1, a, st};
            
            // 2ª Leitura (select=LOW): Responde com Cima, Baixo, Esquerda, Direita, B, C.
            STATE_BC:   p = {up, dw, lf, rg, b, c};
            
            // 3ª e 4ª Leituras: Para um controle de 6 botões, isso seria para X,Y,Z,Mode.
            // Como não os temos, a resposta correta é "nenhum botão pressionado" (tudo em 1).
            // Isso garante compatibilidade com jogos de 6 botões sem causar "botões fantasma".
            STATE_HI_Z_1,
            STATE_HI_Z_2: p = 6'b111111;
            
            // O estado default é uma boa prática de segurança.
            default: p = 6'b111111;
        endcase
    end

endmodule