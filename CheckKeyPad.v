module CheckKeyPad(
    input clock, 
    input reset, 
    input [3:0] keyPad_Col, 
    output reg [3:0] keyPad_Row, 
    output reg [3:0] control
);

always@(posedge clock or negedge reset) begin
    if (!reset) begin 
        keyPad_Row <= 4'b1110;
        control <= 4'b1111; // speed 0
    end
    else begin
        case({keyPad_Row, keyPad_Col})
            8'b1110_1110: control <= 4'b0011; // right speed 2 (7)
            8'b1110_1101: control <= 4'b0001; // right speed 1 (4)
            8'b1110_1011: control <= 4'b0100; // left speed 1 (1)
            8'b1110_0111: control <= 4'b0110; // left speed 2 (0)
            default: control <= 4'b1111; // speed 0
        endcase
        case(keyPad_Row)
            4'b1110: keyPad_Row <= 4'b1110;
        endcase
    end
end
    
endmodule