/****************************************************************************************
* SPI to I2C interface
* January 2007.
*****************************************************************************************/

/* Top module */
module SPI_to_I2C (SPI_sclk, SPI_cs, SPI_miso, SPI_mosi, I2C_sda, I2C_scl );

inout I2C_sda;                     // Bidirectional SDA line
inout I2C_scl;                     // Bidirectional SCL line

input SPI_sclk;                    // SPI clock    
input SPI_cs;                      // SPI chip select
input SPI_mosi;                    // Master out slave in

output SPI_miso;                   // Master in slave out 

wire cpld_clk_w, osc_w, oscena_w; 
assign oscena_w = 1;               // Enable internal oscillator 

wire [7:0] command_reg_w, status_reg_w, data_in_w, data_out_w;
wire count_byte_w;

internal_oss_altufm_osc_7p3 	ufmosc	(.osc(osc_w), .oscena(oscena_w));

divider 	divide	(.osc(osc_w), .cpld_clk(cpld_clk_w)); 

SPI_slave spi (.miso(SPI_miso), .mosi(SPI_mosi), .cs(SPI_cs), .sclk(SPI_sclk), .command_reg(command_reg_w), .status_reg(status_reg_w), .data_in(data_in_w), .data_out(data_out_w), .count_byte1(count_byte_w));

I2C_master i2c (.sda(I2C_sda), .scl(I2C_scl), .cpld_clk(cpld_clk_w), .command_reg(command_reg_w), .status_reg(status_reg_w), .count_byte(count_byte_w), .cs(SPI_cs), .data_in(data_in_w), .data_out(data_out_w));

endmodule

/*****************************************************************************************************************************************************************************************************************/
/* SPI_slave module*/

module SPI_slave ( miso, mosi, cs, sclk , command_reg, data_in, status_reg, data_out, count_bit, count_byte, count, done, done1, count_byte1, count_1);

input mosi, cs, sclk;
input [7:0] status_reg, data_out;   // data to send via miso
output miso;
output [7:0] command_reg, data_in;  // Data to recieve via mosi
output [2:0] count_bit;             // 7 to 0 counter
output count_byte;                  // command/data select  
output done, done1, count_byte1;    // done indicated end of word 
output [3:0] count; 
output [3:0] count_1;

reg miso;
reg [3:0] count;
reg [3:0] count_1; 

/* SPI word length = count_byte * count_bit = 16 */
wire [2:0] count_bit; 
assign count_bit[2] = ~count[2]; 
assign count_bit[1] = ~count[1];
assign count_bit[0] = ~count[0]; 

wire [2:0] count_bit1;
assign count_bit1[2] = ~count_1[2]; 
assign count_bit1[1] = ~count_1[1]; 
assign count_bit1[0] = ~count_1[0];
wire count_byte = count[3];
wire count_byte1 = count_1[3];

reg done;
reg done1;

// When done is high, write over miso is not possible 
always @ (negedge count_byte or posedge cs)
if (cs) begin
    done <= 0;
end else begin
    done <= 1;
end  

// When done1 is high, read over mosi is not possible
always @ (negedge sclk or posedge cs)
if (cs) begin
    done1 <= 0;
end else if ((count_bit == 7) & count_byte1) begin
    done1 <= 1;
end

reg [7:0] command_reg;
reg [7:0] data_in;                       // data recieved via mosi

always @ (posedge sclk or posedge cs) begin
    if (cs) begin
        count <= 0;
    end else begin
        count <= count + 4'h1;
        count_1 <= count;
    end
end

/* Reading the Mosi */
always@ (negedge sclk)
if (~done1)begin
    if (~count_byte1)begin 
        command_reg[count_bit1] = mosi;
    end else begin       
        data_in[count_bit1] = mosi;       
    end
end

/* Writing the Miso */
always@ (posedge sclk) 
begin
  if (~done) begin
    if (count_byte) begin
        miso = data_out[count_bit];
    end else begin
        miso = status_reg[count_bit];
    end
  end
end

endmodule

/*****************************************************************************************************************************************************************************************************************/
/* I2C Master module */
module I2C_master (sda, scl, cpld_clk, command_reg, command_word, status_reg, count_byte, cs, data_in, data_out, sda_out, sda_out1, scl_out, count, sda_is_ack, repeat_start, sda_out_en, start_stop, start, stop);

inout sda;                               
inout scl;
input cpld_clk;
input count_byte, cs;
input [7:0] command_reg, data_in;

output [7:0] status_reg, data_out, command_word;

output sda_out, sda_out1, scl_out, sda_is_ack, repeat_start, sda_out_en, start_stop, start, stop;
output [3:0] count;


reg sda_out;                   // Bidirectional SDA line
reg scl_out;                   // Bidirectional scl Line
reg repeat_start_flag;                 
reg [3:0] count;               // Down count
reg sda_out1;                  // For start_stop signals
reg sda_out_en;                // SDA output is tristate for high and gnd for low;
reg start_stop;                // Bus status 
reg start,stop,reset;          //Detecting start stop conditions on the bus
reg word_retain;               // retaining command word[5] for ack;

reg [7:0] status_reg, data_out, command_word;

wire sda, scl;                     
wire sda_is_ack = count[3];
wire repeat_start;
  
assign scl = scl_out;

/* Controlling the I2C Bus scl line, i.e scl_out */
always@(negedge cpld_clk)
if (scl & ((command_word!=0 | count==0)|~start_stop)) begin
    scl_out = 1'b0;
end else begin
    scl_out = 1'bz;   
end 

/* Initializing the repeat start and stop conditions */
always @ (posedge cpld_clk)
if (repeat_start & scl)begin 
    sda_out1 <= 1'b0;    // repeat start
end else if (scl & command_word[7] & ~start_stop) begin
    sda_out1 <= 1'b0;   //  start sondition
end else if (command_word[4] & ~scl & (start_stop)) begin
    sda_out1 <= 1'b0;
end else if (command_word[4] & scl & (start_stop)) begin
    sda_out1 <= 1'b1;
end else if (~scl) begin
    sda_out1 <= 1'b1;
end else if (cs) begin
    sda_out1 <= 1'b1;
end

/* Repeat start generation */
always@ (posedge cpld_clk)
     if (~command_word[7]) begin
         repeat_start_flag <= 1;
     end else if (scl) begin
         repeat_start_flag <= 0;
     end

assign repeat_start = (command_word[7] & repeat_start_flag & start_stop); 

/* Detecting the start stop on the sda line */
always @ (posedge sda or posedge reset)
if (reset) begin
    stop <= 0;
end else if (scl) begin
    stop <= 1;
end
//cont..
always @ (negedge sda or posedge reset)
if (reset) begin
    start <= 0;
end else if (scl) begin
    start <= 1;
end
//cont..
always @ (negedge scl)
 if (start_stop & start) begin
     reset <= 1;
 end else if (start) begin
     start_stop = 1;
     reset <= 1;
 end else if (stop) begin
     start_stop = 0;
     reset <= 1;     
 end else begin
     reset <= 0;      
 end

/* Down counter */
always @ (negedge scl) 
if (repeat_start) begin
    count <= 4'hF;
end else if (start) begin
    count <= 4'h7;   
end else if (start_stop) begin
   if (sda_is_ack) begin       // count is restored to 7
       count <= 4'h7;
   end else begin
       count <= count - 4'h1;  // count is decremented until zero. 
   end
end else begin
   count <= 4'hF;
end

/* Putting command reg into the command word */
wire count_zero = ~(count[0] | count[1] | count[2] | count [3]); 
always @ ( posedge cs or posedge(count_zero))
begin
    if (count_zero) begin
        command_word <= 0;
    end else begin 
        command_word = command_reg;
    end 
end

/* Word retain for ack during read operation */ 
always@ (negedge scl)
   if (command_word[5]) begin
      word_retain <= 1;
   end else begin
      word_retain <=0;
   end

/* Reading the sda and sending data and ack to SPI side*/
always @ (posedge scl)
if (start_stop) begin
   if (((command_word[5]) & count!= 15)|word_retain) begin
       data_out[count] = sda;
   end else if (count==15) begin
       status_reg[0] = ~sda;
   end
end

/* Sending out address and data on the bus. */
always@(negedge scl)
if (start_stop | start) begin
    if ((command_word[7] | command_word[6]) & (count != 0) & (~repeat_start)) begin
        if (count == 15 & ~data_in[7]) begin sda_out <= 0;
        end else if (count == 7 & ~data_in[6])begin sda_out <= 0;
        end else if (count == 6 & ~data_in[5])begin sda_out <= 0;
        end else if (count == 5 & ~data_in[4])begin sda_out <= 0;
        end else if (count == 4 & ~data_in[3])begin sda_out <= 0;
        end else if (count == 3 & ~data_in[2])begin sda_out <= 0;
        end else if (count == 2 & ~data_in[1])begin sda_out <= 0;
        end else if (count == 1 & ~data_in[0])begin sda_out <= 0;    
        end else sda_out <= 1;
    end else if (word_retain) begin
          if (count==0) sda_out <= 0;
          else sda_out <= 1;
    end else begin
        sda_out <= 1;
    end    
end else begin
    sda_out = 1'b1;
end

/* Controlling the sda output enable */
always @ (sda_out or sda_out1)
begin
    if (~sda_out1) begin 
        sda_out_en <= 1'b0;
    end else if (sda_out) begin
        sda_out_en = 1'bz;
    end else begin
        sda_out_en = 1'b0;
    end
end

assign sda = sda_out_en;

/* Not for synthesis, only for testbench */
initial 
begin
    start = 0;
    stop = 0;
    start_stop = 0;
    sda_out_en = 1'bz;
    scl_out = 1'bz;
    
end

endmodule

/*******************************************************************************************/
/* Internal Oscillator */
module  internal_oss_altufm_osc_7p3
	( 
	osc,
	oscena) /* synthesis synthesis_clearbox=1 */;
	output   osc;
	input   oscena;

	wire  wire_maxii_ufm_block1_osc;

	maxii_ufm   maxii_ufm_block1
	( 
	.arclk(1'b0),
	.ardin(1'b0),
	.arshft(1'b0),
	.bgpbusy(),
	.busy(),
	.drclk(1'b0),
	.drdout(),
	.drshft(1'b0),
	.osc(wire_maxii_ufm_block1_osc),
	.oscena(oscena)
	`ifdef FORMAL_VERIFICATION
	`else
	// synopsys translate_off
	`endif
	,
	.drdin(1'b0),
	.erase(1'b0),
	.program(1'b0)
	`ifdef FORMAL_VERIFICATION
	`else
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.ctrl_bgpbusy(),
	.devclrn(),
	.devpor(),
	.sbdin(),
	.sbdout()
	// synopsys translate_on
	);
	defparam
		maxii_ufm_block1.address_width = 9,
		maxii_ufm_block1.osc_sim_setting = 180000,
		maxii_ufm_block1.lpm_type = "maxii_ufm";
	assign
		osc = wire_maxii_ufm_block1_osc;
endmodule

/******************************************************************************************/
/* Clock Divider */

module divider (osc, cpld_clk);

input osc;
output cpld_clk;

reg [9:0] count;
wire cpld_clk;

assign cpld_clk = count[9];

initial 
count <= 0; 

always @ (posedge(osc))
begin
count = count + 1;
end 

endmodule
 
/*********************************************END************************************************/