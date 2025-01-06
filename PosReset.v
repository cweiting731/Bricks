module PosReset(
    input reset, 
    output reg IsGameOver
);

always @(posedge reset) begin
    IsGameOver <= 1'b0;
end

endmodule