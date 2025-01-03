module VGAtest (
    input clock,
    input reset,
    output hSync,
    output vSync,
    output [3:0] r,
    output [3:0] g,
    output [3:0] b
);

reg [191:0] data;

//assign data[30:2] = {29{1'b1}};


////////////////////////////////////////////////////////////
// 20Hz clock
////////////////////////////////////////////////////////////

reg clk20Hz;
reg [31:0] counter2Hz;
always @(posedge clock or negedge reset)
begin
    if(!reset)
    begin
        clk20Hz <= 1'b0;
		  counter2Hz <= 32'b0;
    end
    else
    begin
		  if(counter2Hz == 32'd1250000)
		  begin
		      counter2Hz <= 32'd0;
				clk20Hz <= ~clk20Hz;
		  end
		  else
		  begin
		  counter2Hz <= counter2Hz + 32'd1;
		  end
    end
end

////////////////////////////////////////////////////////////

reg [7:0] index;
always @(posedge clk20Hz or negedge reset)
begin
    if(!reset)
	 begin
	     data <= 192'b0;
		  index <= 8'b0;
	 end
	 else
	 begin
	     if(index == 8'd192)
		  begin
		      index <= 8'b0;
			   data <= 192'b0;
		  end
		  else
		  begin
	         data[index] <= 1'b1;
		      index <= index + 8'b1;
		  end
	 end
end



VGAdisplay vga(
    .clock(clock),
    .reset(reset),
    .data(data),
    .hSync(hSync),
    .vSync(vSync),
    .r(r),
    .g(g),
    .b(b)
);
endmodule
/*
    this VGAdisplay module display once per pixel time(25MHz)
    
    input clock,                the 25MHz clock
    input reset,                reset signal, active low
    input [191:0] data,      a 16*12 binary data flatted from 2d
    output hSync,               Hor Sync
    output vSync,               Ver Sync
    output reg [3:0] r,         red component
    output reg [3:0] g,         green component
    output reg [3:0] b          blue component
*/