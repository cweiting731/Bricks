module Bricks (
    input clock, 
    input reset, 
    input [3:0] keyPad_col, 
    output [3:0] keyPad_row, 
    output [6:0] sevenDisplay100, 
    output [6:0] sevenDisplay010, 
    output [6:0] sevenDisplay001,
    output [7:0] dot_row, 
    output [7:0] dot_col,
    output VGA_hSync,
    output VGA_vSync,
    output [3:0] VGA_R,
    output [3:0] VGA_G,
    output [3:0] VGA_B
);
wire [9:0] score; // should be limited to 0~999
wire [3:0] score100;
wire [3:0] score010;
wire [3:0] score001;
wire clock100HZ;
wire clock10000HZ;
wire clock2HZ;
wire [3:0] control;

wire [15:0] plate_row;
wire [3:0] ball_rowIndex;
wire [3:0] ball_colIndex;
wire [3:0] ball_direction;
wire [55:0] bricks;
wire [191:0] data;
wire [191:0] game_data;
wire IsGameOver;

FrequencyDivider FD(
    .clock(clock), 
    .reset(reset), 
    .dividerClock10000HZ(clock10000HZ), 
    .dividerClock100HZ(clock100HZ), 
    .dividerClock2HZ(clock2HZ)
);

CheckKeyPad CKP(
    .clock(clock100HZ), 
    .reset(reset), 
    .keyPad_Col(keyPad_col), 
    .keyPad_Row(keyPad_row), 
    .control(control)
);

plate P(
    .data(plate_row),
    .control(control), 
    .reset(reset), 
    .clock(clock2HZ), 
    .data_out(plate_row)
);

ball_movement BM(
    .data(game_data),
    .reset(reset), 
    .clock(clock2HZ), 
    .Ball_rowIndex(ball_rowIndex),
    .Ball_colIndex(ball_colIndex),
    .Ball_direction(ball_direction)
);

Score S(
    .Ball_rowIndex(ball_rowIndex), 
    .Ball_colIndex(ball_colIndex), 
    .Ball_direction(ball_direction),
    .reset(reset), 
    .clock(clock2HZ),
    .Bricks(bricks), 
    .score(score), 
    .IsGameOver(IsGameOver)
);

ScoreProcessor SP(
    .score(score), 
    .score100(score100), 
    .score010(score010), 
    .score001(score001)
);

SevenDisplay SD1(
    .in(score100), 
    .out(sevenDisplay100)
);

SevenDisplay SD2(
    .in(score010), 
    .out(sevenDisplay010)
);

SevenDisplay SD3(
    .in(score001), 
    .out(sevenDisplay001)
);

DotMatrix DM(
    .clock(clock10000HZ), 
    .reset(reset), 
    .control(control), 
    .dot_row(dot_row), 
    .dot_col(dot_col)
);

CombineToMatrix CTM(
    .plate_row(plate_row), 
    .ball_rowIndex(ball_rowIndex), 
    .ball_colIndex(ball_colIndex), 
    .bricks(bricks), 
    .IsGameOver(IsGameOver),
    .data(data),
    .game_data(game_data)
);

VGAdisplay VGA(
    .clock(clock),
    .reset(reset),
    .data(data),     // reserve for someone do the data part
    .hSync(VGA_hSync),
    .vSync(VGA_vSync),
    .r(VGA_R),
    .g(VGA_G),
    .b(VGA_B)
);
endmodule 