/***********************************************************************************
* Test Bench for UFM Memory
* December 2006
************************************************************************************/

`timescale 1us/1ns

module test_ufm_memory;

reg sclk;                   // SCL out
reg sda1;                   // SDA out
reg [7:0] sda_rd;           // Read Value from SDA line

wand latch1;                // SDA
wand latch2;                // SCL

integer seed;

reg [7:0] wr_add ;          // write slave address
reg [7:0] rd_add ;          // read slave address
reg [7:0] b_add  ;          // write memory address
reg [7:0] data   ;          // write data
reg ack_check;              // acknowledgement check

assign latch1 = sda1;
assign latch2 = sclk;

/* Instantiation of the main module */
ufm_memory test(
                .a1(1'b0),
                .a2(1'b0),
                .scl(latch2),
                .sda(latch1)
                );

/* Initialization */
initial begin
	sda1 = 1'b1;
	sclk = 1'b1;
	sda_rd = 8'bz;
	ack_check = 1'b0;
	forever #10 sclk = ~sclk;    // Clock Generation
end


/* Assigning values to address and data */
always @(posedge latch2) begin
    wr_add  = 8'b10110000;
    rd_add  = 8'b10110001;
    b_add   = 8'b10101010;
    
end

always @(posedge ack_check) begin    
    if (ack_check & latch1)               // Checking for acknowledgement.
        $display ("Error at time", $time );
    else
        $display ("Acknowledgement received at time", $time);   
end    

/* Creating dumpfile */
initial begin
    $dumpfile ("test.vcd");
    $dumpvars;
end

/* Monitor and Display */
initial begin
   $display ("\t\ttime,\tscl,\tsda,\tlatch2,\tlatch1");
   $monitor ("%d,\t%b,\t%b,\t%b,\t%b", $time, sclk, sda1, latch2, latch1);
end

/* Sending the slave address for writing data */
always @(negedge latch2) begin   
	#22 sda1 <= 1'b0;              // Start bit
	$display ("Start bit for WRITE operation at time", $time);
	#9  sda1 <= wr_add[7];
	#20 sda1 <= wr_add[6];
	#20 sda1 <= wr_add[5];
	#20 sda1 <= wr_add[4];
	#20 sda1 <= wr_add[3];
	#20 sda1 <= wr_add[2];
	#20 sda1 <= wr_add[1];
	#20 sda1 <= wr_add[0];
	$display ("Slave address sent for WRITE at time", $time);
	#20 sda1 <= 1'b1;
	#8 ack_check <= 1'b1;   
	#10 ack_check <= 1'b0;

/* Sending the memory address for writing data */
@(negedge latch2) begin
    #1  sda1 <= b_add[7];
    #20 sda1 <= b_add[6];
    #20 sda1 <= b_add[5];
    #20 sda1 <= b_add[4];
    #20 sda1 <= b_add[3];
    #20 sda1 <= b_add[2];
    #20 sda1 <= b_add[1];
    #20 sda1 <= b_add[0];
	 $display ("Memory address sent at time", $time);
    #20 sda1 <= 1'b1;
    #8 ack_check <= 1'b1;
    #10 ack_check <= 1'b0;
    
end

    data = $random (seed);               //Generating a random data
    
/* Sending the data to be written */
@(negedge latch2) begin
    #1  sda1 <= data[7];
    #20 sda1 <= data[6];
    #20 sda1 <= data[5];
    #20 sda1 <= data[4];
    #20 sda1 <= data[3];
    #20 sda1 <= data[2];
    #20 sda1 <= data[1];
    #20 sda1 <= data[0];
   	$display ("Random data - %b%b%b%b%b%b%b%b written at time", data[7], data[6], data[5], data[4], data[3], data[2], data[1], data[0], $time);
    #20 sda1 <= 1'b1;
    #8 ack_check <= 1'b1;
    #10 ack_check <= 1'b0;     
end

/* Generation of stop bit */
    #5  sda1 <= 1'b0;
    #10 sda1 <= 1'b1;
   	$display ("Stop bit for WRITE operation at time", $time);
    
    #160;            //Time gap between write and read operation
       
/* Sending slave address for read operation */
@(negedge latch2) begin
	#12 sda1 = 1'b0;
   $display ("Start bit for READ operation at time", $time);
	#9  sda1 <= rd_add[7];
	#20 sda1 <= rd_add[6];
	#20 sda1 <= rd_add[5];
	#20 sda1 <= rd_add[4];
	#20 sda1 <= rd_add[3];
	#20 sda1 <= rd_add[2];
	#20 sda1 <= rd_add[1];
	#20 sda1 <= rd_add[0];
	$display ("Slave address sent for READ at time", $time);
	#20 sda1 = 1'b1;
	#8 ack_check <= 1;
	#10 ack_check <= 1'b0;

/* Storing the read data in sda_rd */
@(negedge latch2) begin          
    #1  sda_rd[7] = latch1;
    #20 sda_rd[6] = latch1;
    #20 sda_rd[5] = latch1;
    #20 sda_rd[4] = latch1;
    #20 sda_rd[3] = latch1;
    #20 sda_rd[2] = latch1;
    #20 sda_rd[1] = latch1;
    #20 sda_rd[0] = latch1;
    if(sda_rd == data)                              //comparing read and written data
         $display ("PASS: Data read correctly - %b%b%b%b%b%b%b%b at time", sda_rd[7], sda_rd[6], sda_rd[5], sda_rd[4], sda_rd[3], sda_rd[2], sda_rd[1], sda_rd[0], $time);
    else
         $display ("Data not read correctly - %b%b%b%b%b%b%b%b at time", sda_rd[7], sda_rd[6], sda_rd[5], sda_rd[4], sda_rd[3], sda_rd[2], sda_rd[1], sda_rd[0], $time);     
    #20 sda_rd = 8'bz; 
end
    
	#5  sda1 = 1'b0;           // Stop bit 
   #10 sda1 = 1'b1;
   $display ("Stop bit for READ at time", $time); 
end

  $stop ;

end

endmodule      

/************************************** End *************************************************************/     