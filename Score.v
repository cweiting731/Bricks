module Score (
    input [3:0] Ball_rowIndex,  // 球的行索引
    input [3:0] Ball_colIndex,  // 球的列索引
    input [1:0] Ball_direction, // 球的方向 (由其他模組控制)
    input clock,                // 時鐘訊號 (假設為原始頻率)
    input reset,                // 重置訊號
    output reg [55:0] Bricks,  // 磚塊狀態 (僅占上面 7 行，每行 16 個磚塊的一半)
    output reg [9:0] score      // 分數
);

    // 2 HZ 時鐘生成
    reg [24:0] clock_divider = 0; // 分頻計數器，假設原始 clock 頻率為 50 MHz
    wire clock2HZ;

    assign clock2HZ = clock_divider[24]; // 使用最高位實現分頻 (50 MHz / 2^25 = 2 Hz)

    always @(posedge clock or negedge reset) begin
        if (!reset)
            clock_divider <= 0; // 分頻器在重置時歸零
        else
            clock_divider <= clock_divider + 1;
    end

    // 行列轉換成一維索引，考慮磚塊僅占上面 7 行，且每個磚塊為 1x2
    wire [6:0] brick_index; // 磚塊索引擴展為 7 位元以支援 7x16
    assign brick_index = Ball_rowIndex * 8 + (Ball_colIndex >> 1); // 每行有 8 個磚塊

    // 初始化與功能實現
    always @(posedge clock2HZ or negedge reset) begin
        if (!reset) begin
            Bricks <= 56'hFFFFFFFFFFFFFF; // 上面 7 行磚塊設為 1
            score <= 10'd0;                                                // 分數重置為 0
        end else begin
            // 碰撞處理
            if (Ball_rowIndex < 7 && Bricks[brick_index] == 1'b1) begin
                Bricks[brick_index] <= 1'b0; // 刪除自身磚塊
                score <= score + 1; // 分數加 1
            end else begin
            end
        end
    end

endmodule

