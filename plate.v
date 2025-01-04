module plate (
    input [15:0] data,       
    input [3:0] control,     
    input reset,             
    input clock,             
    output reg [15:0] data_out
);

    
    parameter PLATE_INITIAL = 16'b0000001111000000; 
    reg [15:0] plate_position;

    
    initial begin
        plate_position = PLATE_INITIAL;
        data_out = PLATE_INITIAL;
    end

    
    always @(posedge clock or negedge reset) begin
        if (!reset) begin
            plate_position <= PLATE_INITIAL;
        end else begin
            case (control)
                4'b1111: begin
                    plate_position <= plate_position;
                end
                4'b0001: begin
                    if (plate_position[0] == 1'b0) 
                        plate_position <= plate_position >> 1;
                end
                4'b0100: begin
                    if (plate_position[15] == 1'b0) 
                        plate_position <= plate_position << 1;
                end
                4'b0011: begin
                    if (plate_position[1:0] == 2'b00) begin
                        plate_position <= plate_position >> 2;
                    end else if (plate_position[0] == 1'b0) begin
                        plate_position <= plate_position >> 1;
                    end
                end
                4'b0110: begin
                    if (plate_position[15:14] == 2'b00) begin 
                        plate_position <= plate_position << 2;
                    end else if (plate_position[15] == 1'b0)begin
                        plate_position <= plate_position << 1;
                    end
                end
                default: begin
                    plate_position <= plate_position;
                end
            endcase
        end
    end

    always @(*) begin
        data_out = plate_position;
    end

endmodule
