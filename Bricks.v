module Bricks (
    input clock, 
    input reset, 
    input [3:0] keyPad_col, 
    output [3:0] keyPad_row, 
    output [6:0] sevenDisplay100, 
    output [6:0] sevenDisplay010, 
    output [6:0] sevenDisplay001,
    output [7:0] dot_row, 
    output [7:0] dot_col
);
wire [9:0] score; // should be limited to 0~999
wire [3:0] score100;
wire [3:0] score010;
wire [3:0] score001;
wire clock100HZ;
wire clock10000HZ;
wire [3:0] control;

FrequencyDivider FD(
    .clock(clock), 
    .reset(reset), 
    .dividerClock10000HZ(clock10000HZ), 
    .dividerClock100HZ(clock100HZ)
);

CheckKeyPad CKP(
    .clock(clock100HZ), 
    .reset(reset), 
    .keyPad_Col(keyPad_col), 
    .keyPad_Row(keyPad_row), 
    .control(control)
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
endmodule 