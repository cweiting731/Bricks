`define TimeExpire100HZ 32'd249999
`define TimeExpire10000HZ 12'd2499
module FrequencyDivider(
	input clock,
	input reset,
	output reg dividerClock100HZ, 
    output reg dividerClock10000HZ
);

reg [31:0] count100HZ;
reg [11:0] count10000HZ;

always@ (posedge clock) begin
	if (!reset) begin
		count100HZ <= 32'd0;
		dividerClock100HZ <= 1'd0;
	end
	else begin
		if (count100HZ == `TimeExpire100HZ) begin
			count100HZ <= 32'd0;
			dividerClock100HZ <= ~dividerClock100HZ;
		end
		else begin
			count100HZ <= count100HZ + 32'd1;
		end
	end
	
    if (count10000HZ == `TimeExpire10000HZ) begin
        count10000HZ <= 12'd0;
        dividerClock10000HZ <= ~dividerClock10000HZ;
    end
    else begin
        count10000HZ <= count10000HZ + 12'd1;
    end
end
endmodule