module ScoreProcessor(
    input [9:0] score, 
    output reg [3:0] score100, 
    output reg [3:0] score010, 
    output reg [3:0] score001
);

always@(*) begin
    score100 = score / 100;
    score010 = (score % 100) / 10;
    score001 = score % 10;
end

endmodule