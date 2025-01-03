module DotMatrix(
	input clock, // 10000HZ
    input [3:0] control,
	input reset,
	output reg [7:0] dot_row, 
	output reg [7:0] dot_col 
);

reg [2:0] rowCount;

always@(posedge clock or negedge reset) begin
	if (!reset) begin
		dot_row <= 8'b0;
		dot_col <= 8'b0;
		rowCount <= 3'd0;
	end
	else begin
		rowCount <= rowCount + 3'd1;
		case(rowCount)
			3'd0: dot_row <= 8'b01111111;
			3'd1: dot_row <= 8'b10111111;
			3'd2: dot_row <= 8'b11011111;
			3'd3: dot_row <= 8'b11101111;
			3'd4: dot_row <= 8'b11110111;
			3'd5: dot_row <= 8'b11111011;
			3'd6: dot_row <= 8'b11111101;
			3'd7: dot_row <= 8'b11111110;
		endcase
		if (control == 4'b1111) begin // stop
			case(rowCount)
				3'd0: dot_col <= 8'b00111100;
				3'd1: dot_col <= 8'b01000010;
				3'd2: dot_col <= 8'b10000001;
				3'd3: dot_col <= 8'b10111101;
				3'd4: dot_col <= 8'b10111101;
				3'd5: dot_col <= 8'b10000001;
				3'd6: dot_col <= 8'b01000010;
				3'd7: dot_col <= 8'b00111100;
			endcase
		end
		else if (control == 4'b0011) begin // right speed 2
			case(rowCount)
				3'd0: dot_col <= 8'b00101000;
				3'd1: dot_col <= 8'b00010100;
				3'd2: dot_col <= 8'b00001010;
				3'd3: dot_col <= 8'b11111111;
				3'd4: dot_col <= 8'b11111111;
				3'd5: dot_col <= 8'b00001010;
				3'd6: dot_col <= 8'b00010100;
				3'd7: dot_col <= 8'b00101000;
			endcase
		end
		else if (control == 4'b0001) begin // right speed 1
			case(rowCount)
				3'd0: dot_col <= 8'b00001000;
				3'd1: dot_col <= 8'b00000100;
				3'd2: dot_col <= 8'b00000010;
				3'd3: dot_col <= 8'b11111111;
				3'd4: dot_col <= 8'b11111111;
				3'd5: dot_col <= 8'b00000010;
				3'd6: dot_col <= 8'b00000100;
				3'd7: dot_col <= 8'b00001000;
			endcase
		end
		else if (control == 4'b0100) begin // left speed 1
			case(rowCount)
				3'd0: dot_col <= 8'b00010000;
				3'd1: dot_col <= 8'b00100000;
				3'd2: dot_col <= 8'b01000000;
				3'd3: dot_col <= 8'b11111111;
				3'd4: dot_col <= 8'b11111111;
				3'd5: dot_col <= 8'b01000000;
				3'd6: dot_col <= 8'b00100000;
				3'd7: dot_col <= 8'b00010000;
			endcase
		end
		else if (control == 4'b0110) begin // left speed 2
			case(rowCount)
				3'd0: dot_col <= 8'b00010100;
				3'd1: dot_col <= 8'b00101000;
				3'd2: dot_col <= 8'b01010000;
				3'd3: dot_col <= 8'b11111111;
				3'd4: dot_col <= 8'b11111111;
				3'd5: dot_col <= 8'b01010000;
				3'd6: dot_col <= 8'b00101000;
				3'd7: dot_col <= 8'b00010100;
			endcase
		end
		else begin
			case(rowCount)
				3'd0: dot_col <= 8'b00000000;
				3'd1: dot_col <= 8'b00000000;
				3'd2: dot_col <= 8'b00000000;
				3'd3: dot_col <= 8'b00000000;
				3'd4: dot_col <= 8'b00000000;
				3'd5: dot_col <= 8'b00000000;
				3'd6: dot_col <= 8'b00000000;
				3'd7: dot_col <= 8'b00000000;
			endcase
		end
	end
end

endmodule 