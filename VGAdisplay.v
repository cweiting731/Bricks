/*
    this VGAdisplay module display once per pixel time(25MHz)
    dependency: RGBgenerator
        work with a data generator that generates rgb component per pixel time(25MHz)

    input clock,                the 25MHz clock
    input reset,                reset signal, active low
    input [307199:0] data,      a 480*640 binary data flatted from 2d
    output hSync,               Hor Sync
    output vSync,               Ver Sync
    output reg [3:0] r,         red component
    output reg [3:0] g,         green component
    output reg [3:0] b          blue component
*/
module VGAdisplay (
    input clock,
    input reset,
    input [307199:0] data,
    output hSync,
    output vSync,
    output reg [3:0] r,
    output reg [3:0] g,
    output reg [3:0] b
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
// RGBgenerator
////////////////////////////////////////////////////////////

wire [11:0] RGBcomponent;
RGBgenerator u1_RGBgenerator(
    .clock(clock),
    .reset(reset),
    .data(data),
    .component(RGBcomponent)
);

////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////
// display
////////////////////////////////////////////////////////////

always @(posedge clk_25MHz or negedge reset)
begin
    if(!reset) 
    begin
        r <= 4'b0000;
        g <= 4'b0000;
        b <= 4'b0000;
    end
    else if(active_flag)
    begin
        r <= RGBcomponent[11:8];
        g <= RGBcomponent[7:4];
        b <= RGBcomponent[3:0];
    end
    else
    begin
        r <= 4'b0000;
        g <= 4'b0000;
        b <= 4'b0000;
    end
end

////////////////////////////////////////////////////////////

endmodule