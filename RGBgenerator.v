/*
    Never use this module directly, use VGAdisplay module instead
    this RGB component data generator only work with VGAdisplay module
    transform generates rgb component per pixel time(25MHz)

    input clock,                the 25MHz clock
    input reset,                reset signal, active low
    input [307199:0] data,      a 480*640 binary data flatted from 2d
    output reg [11:0] component the rgb component data, 11~8 red, 7:4 green, 3:0 blue
*/
module RGBgenerator (
    input clock,
    input reset,
    input [307199:0] data,
    output reg [11:0] component
);

// 640x480@60Hz
// scan sequence: SYNC_PULSE -> BACK_PORCH -> ACTIVE_TIME -> FRONT_PORCH -> 
parameter H_SYNC_PULSE = 96,
          H_BACK_PORCH = 48,
          H_ACTIVE_TIME = 640,
          H_FRONT_PORCH = 16,
          H_LINE_PERIOD = 800;
parameter V_SYNC_PAUSE = 2,
          V_BACK_PORCH = 33,
          V_ACTIVE_TIME = 480,
          V_FRONT_PORCH = 10,
          V_FRAME_PERIOD = 525;

////////////////////////////////////////////////////////////
// 25MHz clock
////////////////////////////////////////////////////////////

reg clk_25MHz;

always @(posedge clock or negedge reset)
begin
    if(!reset)
    begin
        clk_25MHz <= 1'b0;
    end
    else
    begin
        clk_25MHz <= ~clk_25MHz;
    end
end

////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////
// horizontal counter
////////////////////////////////////////////////////////////

reg [11:0] h_count;

always @(posedge clk_25MHz or negedge reset)
begin
    if(!reset)
    begin
        h_count <= 12'd0;
    end
    else if(h_count == H_LINE_PERIOD - 1)
    begin
        h_count <= 12'd0;
    end
    else
    begin
        h_count <= h_count + 12'd1;
    end
end

assign hSync = (h_count < H_SYNC_PULSE) ? 1'b0 : 1'b1;

////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////
// vertical counter
////////////////////////////////////////////////////////////

reg [11:0] v_count;

always @(posedge clk_25MHz or negedge reset)
begin
    if(!reset)
    begin
        v_count <= 12'd0;
    end
    else if(v_count == V_FRAME_PERIOD - 1)
    begin
        v_count <= 12'd0;
    end
    else if(h_count ==  H_LINE_PERIOD - 1)
    begin
        v_count <= v_count + 1'b1;
    end
    else
    begin
        v_count <= v_count;
    end
end

assign vSync = (v_count < V_SYNC_PAUSE) ? 1'b0 : 1'b1;

////////////////////////////////////////////////////////////

wire active_flag;

// assign active_flag in active time
assign active_flag = (h_count >= (H_SYNC_PULSE + H_BACK_PORCH)) &&
                     (h_count < (H_SYNC_PULSE + H_BACK_PORCH + H_ACTIVE_TIME)) &&
                     (v_count >= (V_SYNC_PAUSE + V_BACK_PORCH)) &&
                     (v_count < (V_SYNC_PAUSE + V_BACK_PORCH + V_ACTIVE_TIME));

////////////////////////////////////////////////////////////
// generate component
////////////////////////////////////////////////////////////

reg [18:0] pixelCount;
always @(posedge clk_25MHz or negedge reset)
begin
    if(!reset) 
    begin
        component[11:8] <= 4'b0000;
        component[7:4]  <= 4'b0000;
        component[3:0]  <= 4'b0000;
        pixelCount <= 19'd0;
    end
    else if(active_flag)
    begin
        // assert(pixelCount >= 0 && pixelCount <= 307199)
        pixelCount <= pixelCount + 19'd1;
        // color currently all white
        component[11:8] <= {4{data[pixelCount]}};
        component[7:4]  <= {4{data[pixelCount]}};
        component[3:0]  <= {4{data[pixelCount]}};
    end
    else
    begin
        component[11:8] <= 4'b0000;
        component[7:4]  <= 4'b0000;
        component[3:0]  <= 4'b0000;
        pixelCount <= 19'd0;
    end
end

////////////////////////////////////////////////////////////

endmodule