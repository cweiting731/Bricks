module CombineToMatrix(
    input [15:0] plate_row,
    input [3:0] ball_rowIndex,
    input [3:0] ball_colIndex,
    input [111:0] bricks,
    output reg [191:0] data
);

always @(*)
begin
    data = 192'b0;
    
    data[191:176] = bricks[15:0];
    data[175:160] = bricks[31:16];
    data[159:144] = bricks[47:32];
    data[143:128] = bricks[63:48];
    data[127:112] = bricks[79:64];
    data[111:96] = bricks[95:80];
    data[95:80] = bricks[111:96];

    data[31:16] = plate_row;
    data[(11 - ball_rowIndex) * 16 + ball_colIndex] = 1'b1;
end

endmodule