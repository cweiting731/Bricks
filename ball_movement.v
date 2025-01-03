module ball_movement(data, reset, clock, Ball_rowIndex, Ball_colIndex, Ball_direction);

	input      [191:0] data;
	input              reset, clock;
	output reg [3:0]   Ball_rowIndex, Ball_colIndex;
	output reg [1:0]   Ball_direction;
	reg                ifMove; // move or not
	
	function isSomethingThere;
		input [3:0]   row;
		input [3:0]   col;
		input [191:0] data;
		reg   [7:0]   index;
		
		begin
			if(row < 0 || row >= 12 || col < 0 || col >= 16) begin
				isSomethingThere = 1;
			end
			else begin
				index = row * 16 + col;
				isSomethingThere = data[index];
			end
		end
	endfunction

	wire upward_collision = isSomethingThere(Ball_rowIndex - 1, Ball_colIndex, data);
	wire rightward_collision = isSomethingThere(Ball_rowIndex, Ball_colIndex - 1, data);
	wire downward_collision = isSomethingThere(Ball_rowIndex + 1, Ball_colIndex, data);
	wire leftward_collision = isSomethingThere(Ball_rowIndex, Ball_colIndex + 1, data);
	wire ur_collision = isSomethingThere(Ball_rowIndex - 1, Ball_colIndex - 1, data);
	wire ul_collision = isSomethingThere(Ball_rowIndex - 1, Ball_colIndex + 1, data);
	wire dr_collision = isSomethingThere(Ball_rowIndex + 1, Ball_colIndex - 1, data);
	wire dl_collision = isSomethingThere(Ball_rowIndex + 1, Ball_colIndex + 1, data);
	
	parameter UP_RIGHT = 2'b00;
	parameter UP_LEFT = 2'b01;
	parameter DOWN_RIGHT = 2'b10;
	parameter DOWN_LEFT = 2'b11;
	
	always@(posedge clock or negedge reset) begin
		if(!reset) begin
			Ball_rowIndex <= 4'd9;
			Ball_colIndex <= 4'd9;
			Ball_direction <= UP_RIGHT;
		end
		else begin
			if(ifMove) begin
				case(Ball_direction)
					UP_RIGHT : begin
						Ball_rowIndex <= Ball_rowIndex - 4'd1;
						Ball_colIndex <= Ball_colIndex - 4'd1;
					end
					UP_LEFT : begin
						Ball_rowIndex <= Ball_rowIndex - 4'd1;
						Ball_colIndex <= Ball_colIndex + 4'd1;
					end
					DOWN_RIGHT : begin
						Ball_rowIndex <= Ball_rowIndex + 4'd1;
						Ball_colIndex <= Ball_colIndex - 4'd1;
					end
					default : begin
						Ball_rowIndex <= Ball_rowIndex + 4'd1;
						Ball_colIndex <= Ball_colIndex + 4'd1;
					end
				endcase
			end
		end
	end
	
	always@(posedge clock or negedge reset) begin
		if(!reset) begin
			ifMove <= 1;
		end
		else begin	
			case(Ball_direction)
				UP_RIGHT : begin
					if(upward_collision && !rightward_collision) begin
					   Ball_direction <= DOWN_RIGHT;
					   ifMove <= 0;
					end
					else if(!upward_collision && rightward_collision) begin
					   Ball_direction <= UP_LEFT;
					   ifMove <= 0;
					end
					else if(upward_collision && rightward_collision) begin
					   Ball_direction <= DOWN_LEFT;					
					   ifMove <= 0;
					end
					else if(ur_collision) begin
					   Ball_direction <= DOWN_LEFT;
					   ifMove <= 0;
					end
					else begin
					   ifMove <= 1;
					end
				end
				UP_LEFT: begin
					if(upward_collision && !leftward_collision) begin
					   Ball_direction <= DOWN_LEFT;
					   ifMove <= 0;
					end
					else if(!upward_collision && leftward_collision) begin
					   Ball_direction <= UP_RIGHT;
					   ifMove <= 0;
					end
					else if(upward_collision && leftward_collision) begin
					   Ball_direction <= DOWN_RIGHT;					
					   ifMove <= 0;
					end
					else if(ul_collision) begin
					   Ball_direction <= DOWN_RIGHT;
					   ifMove <= 0;
					end
					else begin
					   ifMove <= 1;
					end
				end
				DOWN_RIGHT : begin
					if(downward_collision && !rightward_collision) begin
					   Ball_direction <= UP_RIGHT;
					   ifMove <= 0;
					end
					else if(!downward_collision && rightward_collision) begin
					   Ball_direction <= DOWN_LEFT;
					   ifMove <= 0;
					end
					else if(downward_collision && rightward_collision) begin
					   Ball_direction <= UP_LEFT;
					   ifMove <= 0;
					end
					else if(dr_collision) begin
					   Ball_direction <= UP_LEFT;
					   ifMove <= 0;
					end
					else begin
					   ifMove <= 1;
					end
				end
				default : begin
					if(downward_collision && !leftward_collision) begin
					   Ball_direction <= UP_LEFT;
					   ifMove <= 0;
					end
					else if(!downward_collision && leftward_collision) begin
					   Ball_direction <= DOWN_RIGHT;
					   ifMove <= 0;
					end
					else if(downward_collision && leftward_collision) begin
					   Ball_direction <= UP_RIGHT;
					   ifMove <= 0;
					end
					else if(dl_collision) begin
					   Ball_direction <= UP_RIGHT;
					   ifMove <= 0;
					end
					else begin
					   ifMove <= 1;
					end
				end
			endcase
		end
	end
	
endmodule
			
