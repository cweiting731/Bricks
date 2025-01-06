module CombineToMatrix(
    input [15:0] plate_row,
    input [3:0] ball_rowIndex,
    input [3:0] ball_colIndex,
    input [55:0] bricks,
    output reg [191:0] data, 
    output reg [191:0] game_data
);

reg [111:0] expanded_bricks;
integer i;
integer ballIndex;

always @(*)
begin
    data = 192'b0;
    
    for (i = 0; i < 56; i = i + 1) begin : expand_bits
        expanded_bricks[2*i +: 2] = {bricks[i], bricks[i]};
    end
    
    data[191:176] = expanded_bricks[15:0];
    data[175:160] = expanded_bricks[31:16];
    data[159:144] = expanded_bricks[47:32];
    data[143:128] = expanded_bricks[63:48];
    data[127:112] = expanded_bricks[79:64];
    data[111:96] = expanded_bricks[95:80];
    data[95:80] = expanded_bricks[111:96];

    data[31:16] = plate_row;
    ballIndex = (11 - ball_rowIndex) * 16 + ball_colIndex;
    data[ballIndex] = 1'b1;



    game_data = 192'b0;
    game_data[111:0] = expanded_bricks[111:0];
    game_data[175:160] = plate_row;
    game_data[ball_rowIndex * 16 + ball_colIndex] = 1'b1;
end

endmodule