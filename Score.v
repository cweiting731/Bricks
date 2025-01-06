module Score (
    input [3:0] Ball_rowIndex,  // 球的行索引
    input [3:0] Ball_colIndex,  // 球的列索引
    input [1:0] Ball_direction, // 球的方向 (由其他模組控制)
    input clock,                // 時鐘訊號 (假設為原始頻率) // 2HZ
    input reset,                // 重置訊號
    output reg [71:0] Bricks,  // 磚塊狀態 (僅占上面 7 行，每行 16 個磚塊的一半)
    output reg [9:0] score,      // 分數
	 output reg IsGameOver
);

    // 行列轉換成一維索引，考慮磚塊僅占上面 7 行，且每個磚塊為 1x2
    wire [6:0] brick_index; // 磚塊索引擴展為 7 位元以支援 7x16
    assign brick_index = (Ball_rowIndex-1) * 8 + (Ball_colIndex >> 1); // 每行有 8 個磚塊
	wire [6:0] brick_index_plus_7;
    assign brick_index_plus_7 = brick_index + 7;

    // 初始化與功能實現
    always @(posedge clock or negedge reset) begin
        if (!reset) begin
            Bricks <= 64'hFFFFFFFFFFFFFFFF; // 上面 7 行磚塊設為 1
				Bricks[71:40] <= 32'b0;
            score <= 10'd0; 				// 分數重置為 0
				IsGameOver <= 1'b0;
		end else if (IsGameOver == 1'b1) begin
            Bricks <= 64'hFFFFFFFFFFFFFFFF; // 上面 7 行磚塊設為 1
				Bricks[71:40] <= 32'b0;
            score <= 10'd0; 				// 分數重置為 0
				IsGameOver <= 1'b1;
	    end else begin
            // 碰撞處理
				if (Ball_rowIndex <= 7 && Ball_rowIndex != 0) begin
					if (Bricks[brick_index] == 1'b1 && Bricks[brick_index+7] == 1'b1 && Ball_colIndex[0] == 1'b0 && Ball_direction == 2'b00 && Ball_colIndex != 0 && Ball_rowIndex != 0) begin
						 Bricks[brick_index] <= 1'b0;
						 Bricks[brick_index+7] <= 1'b0; // 刪除自身磚塊
						 score <= score + 2; // 分數加 1
					end else if (Bricks[brick_index] == 1'b1 && Bricks[brick_index+15] == 1'b1 && Ball_colIndex[0] == 1'b0 && Ball_direction == 2'b00 && Ball_colIndex != 0 && Ball_rowIndex != 0) begin
						 Bricks[brick_index] <= 1'b0; // 刪除自身磚塊
						 Bricks[brick_index+15] <= 1'b0;
						 score <= score + 2; // 分數加 1
					end else if (Bricks[brick_index] == 1'b1 && Bricks[brick_index+9] == 1'b1 && Ball_colIndex[0] == 1'b1 && Ball_direction == 2'b01 && Ball_colIndex != 15 && Ball_rowIndex != 0) begin
						 Bricks[brick_index] <= 1'b0; // 刪除自身磚塊
						 Bricks[brick_index+9] <= 1'b0; // 刪除自身磚塊
						 score <= score + 2; // 分數加 1
					end else if (Bricks[brick_index] == 1'b1 && Bricks[brick_index+17] == 1'b1 && Ball_colIndex[0] == 1'b1 && Ball_direction == 2'b01 && Ball_colIndex != 15 && Ball_rowIndex != 0) begin
						 Bricks[brick_index] <= 1'b0; // 刪除自身磚塊
						 Bricks[brick_index+17] <= 1'b0; // 刪除自身磚塊
						 score <= score + 2; // 分數加 1
					end else if (Bricks[brick_index+16] == 1'b1 && Bricks[brick_index+7] == 1'b1 && Ball_colIndex[0] == 1'b0 && Ball_direction == 2'b10 && Ball_colIndex != 0) begin
						 Bricks[brick_index+16] <= 1'b0; // 刪除自身磚塊
						 Bricks[brick_index+7] <= 1'b0; // 刪除自身磚塊
						 score <= score + 2; // 分數加 1
					end else if (Bricks[brick_index-1] == 1'b1 && Bricks[brick_index+16] == 1'b1 && Ball_colIndex[0] == 1'b0 && Ball_direction == 2'b10 && Ball_colIndex != 0 && Ball_rowIndex != 0) begin
						 Bricks[brick_index+16] <= 1'b0; // 刪除自身磚塊
						 Bricks[brick_index-1] <= 1'b0; // 刪除自身磚塊
						 score <= score + 2; // 分數加 1
					end else if (Bricks[brick_index+16] == 1'b1 && Bricks[brick_index+9] == 1'b1 && Ball_colIndex[0] == 1'b1 && Ball_direction == 2'b11 && Ball_colIndex != 15) begin
						 Bricks[brick_index+16] <= 1'b0; // 刪除自身磚塊
						 Bricks[brick_index+9] <= 1'b0; // 刪除自身磚塊
						 score <= score + 2; // 分數加 1
					end else if (Bricks[brick_index+16] == 1'b1 && Bricks[brick_index+1] == 1'b1 && Ball_colIndex[0] == 1'b1 && Ball_direction == 2'b11 && Ball_colIndex != 15 && Ball_rowIndex != 0) begin
						 Bricks[brick_index+16] <= 1'b0; // 刪除自身磚塊
						 Bricks[brick_index+1] <= 1'b0; // 刪除自身磚塊
						 score <= score + 2; // 分數加 1
					end else if (Bricks[brick_index] == 1'b1 && Ball_rowIndex != 0) begin
						 Bricks[brick_index] <= 1'b0;
						 score <= score + 1; // 分數加 1
					end else if (Bricks[brick_index+16] == 1'b1) begin
						 Bricks[brick_index+16] <= 1'b0;
						 score <= score + 1; // 分數加 1
					end else if (Bricks[brick_index+7] == 1'b1 && Ball_colIndex[0] == 1'b0 && Ball_colIndex != 0) begin //right
						 Bricks[brick_index+7] <= 1'b0; // 刪除自身磚塊
						 score <= score + 1; // 分數加 1
					end else if (Bricks[brick_index+9] == 1'b1 && Ball_colIndex[0] == 1'b1 && Ball_colIndex != 15) begin //left
						 Bricks[brick_index+9] <= 1'b0; // 刪除自身磚塊
						 score <= score + 1; // 分數加 1
					end else if (Bricks[brick_index-1] == 1'b1 && Ball_colIndex[0] == 1'b0 && Ball_direction == 2'b00 && Ball_colIndex != 0 && Ball_rowIndex != 0) begin //right
						 Bricks[brick_index-1] <= 1'b0; // 刪除自身磚塊
						 score <= score + 1; // 分數加 1
					end else if (Bricks[brick_index+1] == 1'b1 && Ball_colIndex[0] == 1'b1 && Ball_direction == 2'b01 && Ball_colIndex != 15 && Ball_rowIndex != 0) begin //right
						 Bricks[brick_index+1] <= 1'b0; // 刪除自身磚塊
						 score <= score + 1; // 分數加 1
					end else if (Bricks[brick_index+15] == 1'b1 && Ball_colIndex[0] == 1'b0 && Ball_direction == 2'b10 && Ball_colIndex != 0) begin //right
						 Bricks[brick_index+15] <= 1'b0; // 刪除自身磚塊
						 score <= score + 1; // 分數加 1
					end else if (Bricks[brick_index+17] == 1'b1 && Ball_colIndex[0] == 1'b1 && Ball_direction == 2'b11 && Ball_colIndex != 15) begin //right
						 Bricks[brick_index+17] <= 1'b0; // 刪除自身磚塊
						 score <= score + 1; // 分數加 1
					end else begin
					    score <= score + 0;
					end
				end else if (Ball_rowIndex == 0) begin
					if (Bricks[brick_index_plus_7] == 1'b1 && Ball_colIndex[0] == 1'b0 && Ball_colIndex != 0) begin //right
						 Bricks[brick_index_plus_7] <= 1'b0; // 刪除自身磚塊
						 score <= score + 1; // 分數加 1
					end else if (Bricks[brick_index+2] == 1'b1 && Ball_colIndex[0] == 1'b1 && Ball_colIndex != 15) begin //left
						 Bricks[brick_index_plus_7+2] <= 1'b0; // 刪除自身磚塊
						 score <= score + 1; // 分數加 1
					end else begin
						score <= score + 0;
					end
				end else if (Ball_rowIndex == 11) begin
				   IsGameOver <= 1'b1;
					score <= 10'd0;
			   end else begin
				   score <= score + 0;
				end
        end
    end

endmodule
