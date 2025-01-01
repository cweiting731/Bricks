module CombineToMatrix(
    input [15:0] plate_row;
    input [3:0] ball_rowIndex;
    input [3:0] ball_colIndex;
    input [95:0] bricks;
    output [191:0] data;
);

always @(*) begin
    data = 192'b0;
    data[95:0] = bricks;
    data[175:160] = plate_row;
    data[ball_rowIndex * 16 + ball_colIndex] = 1'b1;
end

endmodule