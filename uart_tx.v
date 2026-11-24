module uart_tx #(
    parameter CLKS_PER_BIT = 5208
)(
    input wire clk,
    input wire rst,
    input wire tx_start,
    input wire [7:0] tx_data,
    output reg tx,
    output wire tx_busy
);

    localparam IDLE  = 2'b00,
               START = 2'b01,
               DATA  = 2'b10,
               STOP  = 2'b11;

    reg [1:0] state;
    reg [15:0] clk_count;
    reg [2:0] bit_index;
    reg [7:0] data_reg;

    assign tx_busy = (state != IDLE);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            tx <= 1'b1;
            clk_count <= 0;
            bit_index <= 0;
            data_reg <= 0;
        end else begin
            case (state)

                IDLE: begin
                    tx <= 1'b1;
                    clk_count <= 0;
                    if (tx_start) begin
                        data_reg <= tx_data;
                        tx <= 1'b0;
                        state <= START;
                    end
                end

                START: begin
                    if (clk_count == CLKS_PER_BIT-1) begin
                        clk_count <= 0;
                        bit_index <= 0;
                        tx <= data_reg[0];
                        state <= DATA;
                    end else
                        clk_count <= clk_count + 1;
                end

                DATA: begin
                    if (clk_count == CLKS_PER_BIT-1) begin
                        clk_count <= 0;
                        if (bit_index == 7) begin
                            tx <= 1'b1;
                            state <= STOP;
                        end else begin
                            bit_index <= bit_index + 1;
                            tx <= data_reg[bit_index + 1];
                        end
                    end else
                        clk_count <= clk_count + 1;
                end

                STOP: begin
                    if (clk_count == CLKS_PER_BIT-1) begin
                        clk_count <= 0;
                        state <= IDLE;
                    end else
                        clk_count <= clk_count + 1;
                end

            endcase
        end
    end

endmodule
