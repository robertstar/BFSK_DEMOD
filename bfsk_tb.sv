`timescale 1ns / 1ps
`define EOF -1
`define NULL 0

module bfsk_tb;

// localparam width = 32; //width of x and y
// duration for each bit = 20 * timescale = 20 * 1 ns  = 20ns for 50Mhz


localparam period_50Mhz = 10;  
localparam period_200k = 2500;
localparam period_48k = 10416;

reg clk_48k;
reg clk_50Mhz;
	
// Inputs
reg [7:0] signal=0;   //register declaration for storing each line of file.
wire signed [15:0] out;
wire det;
wire en;
wire sync;

integer   fd;       //file descriptors
reg [8*10:1] str; 
integer samples;
integer code;

discr #( .DEPTH_D(20), .DEPTH_S(1) ) discr_inst( .clk(clk_48k), .din(signal), .dout(out), .det(det), .en(en) , .sync(sync) );


initial begin
    clk_48k    =0;
	clk_50Mhz  =0;
	samples    =10000;
end

always
	#period_48k clk_48k = !clk_48k;// wait for period
	
always 
	#period_50Mhz clk_50Mhz = !clk_50Mhz;


//open file and read
initial begin
	@(posedge clk_48k); 
	//rst<=1'b0;
	fd=$fopen("bfsk_signal.bit","r");
	//while(! $feof(fd)) begin
	while(samples>0) begin
        
		//code = $fgets ( str, fd );
		//code = $sscanf(str, "%h", signal);
		//$display ("Line: %s", str);
		
		signal = $fgetc(fd);
 		samples<=samples-1'b1;
 		@(posedge clk_48k);
	end
	$fclose(fd);
	$finish;
end	

// initial begin
// 	@(posedge clk); 
// 	fd=$fopen("cic_out_signal.bin","a+");
// 	while(samples>0) begin
// 		@(posedge clk);
// 		$fwrite(fd,"%c%c",cic_d_out_real[7:0], cic_d_out_real[15:8]);
// 		$fwrite(fd,"%c%c",SINout2[7:0], SINout2[15:8]);
// 		$fwrite(fd,"%c",sinewave);
// 		samples<=samples-1'b1;
// 	end
// 	$fclose(fd);
// 	$finish;
// end		
	
	
//создаем файл VCD для последующего анализа сигналов
initial begin
 	$dumpfile("bfsk.vcd");
  	$dumpvars(0,bfsk_tb);
end
	
// Monitor the output
//initial
//$monitor($time, , COSout, , SINout, , angle, , A);
	
endmodule
