module uart_rx #(
    parameter CLKS_PER_BIT = 8
)(
    input wire clk,
    input wire rst,
    input wire rx,
    output reg [7:0] rx_data,
    output reg rx_done
);

    localparam IDLE  = 2'b00,
               START = 2'b01,
               DATA  = 2'b10,
               STOP  = 2'b11;

    reg [1:0] state;
    reg [15:0] clk_count;
    reg [2:0] bit_index;
    reg [7:0] rx_shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            clk_count <= 0;
            bit_index <= 0;
            rx_shift_reg <= 0;
            rx_data <= 0;
            rx_done <= 0;
        end else begin
            rx_done <= 0;

            case (state)

                IDLE: begin
                    clk_count <= 0;
                    if (!rx) begin
                        state <= START;
                    end
                end

                START: begin
                    if (clk_count == (CLKS_PER_BIT/2)-1) begin
                        clk_count <= 0;
                        if (!rx) begin
                            bit_index <= 0;
                            state <= DATA;
                        end else begin
                            state <= IDLE;
                        end
                    end else
                        clk_count <= clk_count + 1;
                end

                DATA: begin
                    if (clk_count == CLKS_PER_BIT-1) begin
                        clk_count <= 0;
                        rx_shift_reg[bit_index] <= rx;

                        if (bit_index == 7)
                            state <= STOP;
                        else
                            bit_index <= bit_index + 1;
                    end else
                        clk_count <= clk_count + 1;
                end

                STOP: begin
                    if (clk_count == CLKS_PER_BIT-1) begin
                        clk_count <= 0;
                        if (rx) begin
                            rx_data <= rx_shift_reg;
                            rx_done <= 1;
                        end
                        state <= IDLE;
                    end else
                        clk_count <= clk_count + 1;
                end

            endcase
        end
    end

endmodule
