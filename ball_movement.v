module ball_movement(data, reset, clock, Ball_rowIndex, Ball_colIndex, Ball_direction);

	input      [191:0] data;
	input              reset, clock;
	output reg [3:0]   Ball_rowIndex, Ball_colIndex;
	output reg [1:0]   Ball_direction;


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

	wire upward_collision = (Ball_rowIndex == 4'd0) ? 1 : isSomethingThere(Ball_rowIndex - 1, Ball_colIndex, data);
	wire rightward_collision = (Ball_colIndex == 4'd0) ? 1 : isSomethingThere(Ball_rowIndex, Ball_colIndex - 1, data);
	wire downward_collision = (Ball_rowIndex == 4'd11) ? 1 : isSomethingThere(Ball_rowIndex + 1, Ball_colIndex, data);
	wire leftward_collision = (Ball_colIndex == 4'd15) ? 1 : isSomethingThere(Ball_rowIndex, Ball_colIndex + 1, data);
	
	wire ur_collision = (Ball_rowIndex == 4'd0 || Ball_colIndex == 4'd0) ? 1 : isSomethingThere(Ball_rowIndex - 1, Ball_colIndex - 1, data);
	wire ul_collision = (Ball_rowIndex == 4'd0 || Ball_colIndex == 4'd15) ? 1 : isSomethingThere(Ball_rowIndex - 1, Ball_colIndex + 1, data);
	wire dr_collision = (Ball_rowIndex == 4'd11 || Ball_colIndex == 4'd0) ? 1 : isSomethingThere(Ball_rowIndex + 1, Ball_colIndex - 1, data);
	wire dl_collision = (Ball_rowIndex == 4'd11 || Ball_colIndex == 4'd15) ? 1 : isSomethingThere(Ball_rowIndex + 1, Ball_colIndex + 1, data);

	parameter UP_RIGHT = 2'b00;
	parameter UP_LEFT = 2'b01;
	parameter DOWN_RIGHT = 2'b10;
	parameter DOWN_LEFT = 2'b11;
	
	reg [1:0] next_direction;
	reg [3:0] next_rowIndex, next_colIndex;

	always@(posedge clock or negedge reset) begin
		if(!reset) begin
			Ball_rowIndex <= 4'd9;
			Ball_colIndex <= 4'd7;
			Ball_direction <= UP_RIGHT;
		end
		else begin
			Ball_rowIndex <= next_rowIndex;
			Ball_colIndex <= next_colIndex;
			Ball_direction <= next_direction;
		end
	end

	always@(*) begin
		next_rowIndex = Ball_rowIndex;
		next_colIndex = Ball_colIndex;
		next_direction = Ball_direction;

		case(Ball_direction)
			UP_RIGHT : begin
				if(upward_collision && !rightward_collision) begin
					if(dr_collision) begin
						next_direction = DOWN_LEFT;
					end
					else begin
						next_direction = DOWN_RIGHT;
					end
				end
				else if(!upward_collision && rightward_collision) begin
					if(ul_collision) begin
						next_direction = DOWN_LEFT;
					end
					else begin
						next_direction = UP_LEFT;
					end
				end
				else if(upward_collision && rightward_collision) begin
					next_direction = DOWN_LEFT;					
				end
				else if(ur_collision) begin
					next_direction = DOWN_LEFT;
				end
			end
			
			UP_LEFT: begin
				if(upward_collision && !leftward_collision) begin
					if(dl_collision) begin
						next_direction = DOWN_RIGHT;
					end
					else begin
						next_direction = DOWN_LEFT;
					end
				end
				else if(!upward_collision && leftward_collision) begin
					if(ur_collision) begin
						next_direction = DOWN_RIGHT;
					end
					else begin
						next_direction = UP_RIGHT;
					end
				end
				else if(upward_collision && leftward_collision) begin
					next_direction = DOWN_RIGHT;					
				end
				else if(ul_collision) begin
					next_direction = DOWN_RIGHT;
				end
			end
			
			DOWN_RIGHT : begin
				if(downward_collision && !rightward_collision) begin
					if(ur_collision) begin
						next_direction = DOWN_LEFT;
					end
					else begin
						next_direction = UP_RIGHT;
					end
				end
				else if(!downward_collision && rightward_collision) begin
					if(dl_collision) begin
						next_direction = UP_LEFT;
					end
					else begin
						next_direction = DOWN_LEFT;
					end
				end
				else if(downward_collision && rightward_collision) begin
					next_direction = UP_LEFT;
				end
				else if(dr_collision) begin
					next_direction = UP_LEFT;
				end
			end
				
			default : begin
				if(downward_collision && !leftward_collision) begin
					if(ul_collision) begin
						next_direction = UP_RIGHT;
					end
					else begin
						next_direction = UP_LEFT;
					end
				end
				else if(!downward_collision && leftward_collision) begin
					if(ur_collision) begin
						next_direction = UP_RIGHT;
					end
					else begin
						next_direction = DOWN_RIGHT;
					end
				end
				else if(downward_collision && leftward_collision) begin
					next_direction = UP_RIGHT;
				end
				else if(dl_collision) begin
					next_direction = UP_RIGHT;
				end
			end
		endcase
		
		case(next_direction)
			UP_RIGHT : begin
				next_rowIndex = Ball_rowIndex - 4'd1;
				next_colIndex = Ball_colIndex - 4'd1;
			end
			UP_LEFT : begin
				next_rowIndex = Ball_rowIndex - 4'd1;
				next_colIndex = Ball_colIndex + 4'd1;
			end
			DOWN_RIGHT : begin
				next_rowIndex = Ball_rowIndex + 4'd1;
				next_colIndex = Ball_colIndex - 4'd1;
			end
			default : begin
				next_rowIndex = Ball_rowIndex + 4'd1;
				next_colIndex = Ball_colIndex + 4'd1;
			end
		endcase
	end
endmodule
