/***************************************************************************************
* TESTBENCH FOR SPI TO I2C
* January 2007
***************************************************************************************/
`timescale 10us/100ns

module SPI_to_I2C_test;

wand I2C_sda;        
wand I2C_scl;
wire SPI_miso;

reg SPI_sclk;
reg SPI_cs;
reg SPI_mosi;

SPI_to_I2C tb (SPI_sclk, SPI_cs, SPI_miso, SPI_mosi, I2C_sda, I2C_scl);

reg I2C_sda_in;
reg scl_in;
reg I2C_scl_in;

reg [3:0] clk_count;
assign I2C_sda = I2C_sda_in;
assign I2C_scl = scl_in;

reg [7:0]command, data_send, data_store, data_recieve;
reg check1, check2, check3;
reg clk_en;
integer r_seed;

/* Generating the SPI Master Clock */ 
initial
begin
    forever #5 SPI_sclk = (~SPI_sclk & (clk_en));
end

always@ (negedge (clk_count==0) )
clk_en = 0;

always@ (negedge SPI_cs)
clk_en = 1;

always@ (negedge SPI_sclk) begin
    clk_count = clk_count - 1;
end       
  
/* Generating the SPI side conditions */  
initial 
begin
   I2C_sda_in <= 1;
   scl_in <= 1;
   SPI_sclk <= 0;
   SPI_cs <= 1;
   SPI_mosi <= 0;
   clk_count <= 15;
   r_seed = 12;
      
   /* Sending I2C start condition with a slave address */   
   #10;
   SPI_cs <= 0 ;
   clk_count <= 15;
   command = 10000000;                // Command for start + slave address
   //data_send = $random(r_seed);
   data_send = 8'h90;                 // Slave Address;
   @(posedge SPI_sclk)
   SPI_mosi <= command[7];
   @(posedge SPI_sclk)
   SPI_mosi <= command[6];        
   @(posedge SPI_sclk)
   SPI_mosi <= command[5];
   @(posedge SPI_sclk)
   SPI_mosi <= command[4];
   @(posedge SPI_sclk)
   SPI_mosi <= command[3];
   @(posedge SPI_sclk)
   SPI_mosi <= command[2];
   @(posedge SPI_sclk)
   SPI_mosi <= command[1];
   @(posedge SPI_sclk)
   SPI_mosi <= command[0];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[7];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[6];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[5];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[4];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[3];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[2];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[1];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[0];
   #10 SPI_cs = 1;
   
   /* Writing a byte */
   #500;
   SPI_cs <= 0 ;
   clk_count <= 15;
   command = 01000000;                    // Command for writing a byte
   //data_send = $random(r_seed);
   data_send = 8'h0C;
   @(posedge SPI_sclk)
   SPI_mosi <= command[7];
   @(posedge SPI_sclk)
   SPI_mosi <= command[6];        
   @(posedge SPI_sclk)
   SPI_mosi <= command[5];
   @(posedge SPI_sclk)
   SPI_mosi <= command[4];
   @(posedge SPI_sclk)
   SPI_mosi <= command[3];
   @(posedge SPI_sclk)
   SPI_mosi <= command[2];
   @(posedge SPI_sclk)
   SPI_mosi <= command[1];
   @(posedge SPI_sclk)
   SPI_mosi <= command[0];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[7];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[6];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[5];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[4];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[3];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[2];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[1];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[0];
   #10 SPI_cs = 1;
   
   /* Generating repeat start followed by slave address */ 
   #500;
   SPI_cs <= 0 ;
   clk_count <= 15;
   command = 10000000;        //Command for start following
                              // by slave address
   //data_send = $random(r_seed);
   data_send = 8'h91;
   @(posedge SPI_sclk)
   SPI_mosi <= command[7];
   @(posedge SPI_sclk)
   SPI_mosi <= command[6];        
   @(posedge SPI_sclk)
   SPI_mosi <= command[5];
   @(posedge SPI_sclk)
   SPI_mosi <= command[4];
   @(posedge SPI_sclk)
   SPI_mosi <= command[3];
   @(posedge SPI_sclk)
   SPI_mosi <= command[2];
   @(posedge SPI_sclk)
   SPI_mosi <= command[1];
   @(posedge SPI_sclk)
   SPI_mosi <= command[0];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[7];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[6];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[5];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[4];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[3];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[2];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[1];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[0];
   #10 SPI_cs = 1; 
   
   /* Read Command Sent */
   #500;
   SPI_cs <= 0 ;
   clk_count <= 15;
   command = 9'h20;            // Command to read a byte
   //data_send = ;
   data_send = 8'hFF;
   @(posedge SPI_sclk)
   SPI_mosi <= command[7];
   @(posedge SPI_sclk)
   SPI_mosi <= command[6];        
   @(posedge SPI_sclk)
   SPI_mosi <= command[5];
   @(posedge SPI_sclk)
   SPI_mosi <= command[4];
   @(posedge SPI_sclk)
   SPI_mosi <= command[3];
   @(posedge SPI_sclk)
   SPI_mosi <= command[2];
   @(posedge SPI_sclk)
   SPI_mosi <= command[1];
   @(posedge SPI_sclk)
   SPI_mosi <= command[0];
   /* Dummy data Sent */
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[7];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[6];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[5];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[4];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[3];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[2];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[1];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[0];
   #10 SPI_cs = 1;
   
   /* Read data recieved */
   #500;
   SPI_cs <= 0 ;
   clk_count <= 15;
   command = 8'h00;       // Command to do nothing on I2C bus
                          // Just read the previous byte recieved  
   //data_send = $random(r_seed) ;
   data_send = 8'hFF;
   @(posedge SPI_sclk)
   SPI_mosi <= command[7];
   @(posedge SPI_sclk)
   SPI_mosi <= command[6];        
   @(posedge SPI_sclk)
   SPI_mosi <= command[5];
   @(posedge SPI_sclk)
   SPI_mosi <= command[4];
   @(posedge SPI_sclk)
   SPI_mosi <= command[3];
   @(posedge SPI_sclk)
   SPI_mosi <= command[2];
   @(posedge SPI_sclk)
   SPI_mosi <= command[1];
   @(posedge SPI_sclk)
   SPI_mosi <= command[0];
   @(posedge SPI_sclk)
   @(negedge SPI_sclk)
   data_store[7] <= SPI_miso;
   @(negedge SPI_sclk)
   data_store[6] <= SPI_miso;
   @(negedge SPI_sclk)
   data_store[5] <= SPI_miso;
   @(negedge SPI_sclk)
   data_store[4] <= SPI_miso;
   @(negedge SPI_sclk)
   data_store[3] <= SPI_miso;
   @(negedge SPI_sclk)
   data_store[2] <= SPI_miso;
   @(negedge SPI_sclk)
   data_store[1] <= SPI_miso;
   @(negedge SPI_sclk)
   data_store[0] <= SPI_miso;
   #10 SPI_cs = 1;
    check3 = 1;
   
   /* Stop condition generated on the I2C bus */   
   #500;
   SPI_cs <= 0 ;
   clk_count <= 15;
   command = 8'h10;              // Command For Stop Condition
   //data_send = ;
   data_send = 8'hFF;
   @(posedge SPI_sclk)
   SPI_mosi <= command[7];
   check3 = 0;
   @(posedge SPI_sclk)
   SPI_mosi <= command[6];        
   @(posedge SPI_sclk)
   SPI_mosi <= command[5];
   @(posedge SPI_sclk)
   SPI_mosi <= command[4];
   @(posedge SPI_sclk)
   SPI_mosi <= command[3];
   @(posedge SPI_sclk)
   SPI_mosi <= command[2];
   @(posedge SPI_sclk)
   SPI_mosi <= command[1];
   @(posedge SPI_sclk)
   SPI_mosi <= command[0];
   /* Dummy data Sent */
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[7];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[6];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[5];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[4];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[3];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[2];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[1];
   @(posedge SPI_sclk)
   SPI_mosi <= data_send[0];
   #10 SPI_cs = 1;
   
   #500
   $display ("TestBench complete", $time);
   $stop;
                  
end    

initial 
begin
    
    check1 = 0;
    check2 = 0;
    check3 = 0;
    
    /* Verifying address sent on SDA line*/
    @ (negedge I2C_sda)
    @ (posedge I2C_scl)
    data_store[7] = I2C_sda;
    @ (posedge I2C_scl)
    data_store[6] = I2C_sda;
    @ (posedge I2C_scl)
    data_store[5] = I2C_sda;
    @ (posedge I2C_scl)
    data_store[4] = I2C_sda;
    @ (posedge I2C_scl)
    data_store[3] = I2C_sda;
    @ (posedge I2C_scl)
    data_store[2] = I2C_sda;
    @ (posedge I2C_scl)
    data_store[1] = I2C_sda;
    @ (posedge I2C_scl)
    data_store[0] = I2C_sda;
    @ (negedge I2C_scl);
    if (data_store == data_send) begin
        I2C_sda_in <= 0;        
    end
    check1 = 1;
    @ (negedge I2C_scl);
    I2C_sda_in <= 1;
    check1 = 0;
    
    /* Verifying data send on the SDA line */
    @ (posedge I2C_scl);
    data_store[7] = I2C_sda;
    @ (posedge I2C_scl);
    data_store[6] = I2C_sda;
    @ (posedge I2C_scl);
    data_store[5] = I2C_sda;
    @ (posedge I2C_scl);
    data_store[4] = I2C_sda;
    @ (posedge I2C_scl);
    data_store[3] = I2C_sda;
    @ (posedge I2C_scl);
    data_store[2] = I2C_sda;
    @ (posedge I2C_scl);
    data_store[1] = I2C_sda;
    @ (posedge I2C_scl);
    data_store[0] = I2C_sda;
    @ (negedge I2C_scl);
    if (data_store == data_send) begin
        I2C_sda_in <= 0;    
    end
    check2 = 1;
    @ (negedge I2C_scl);
    I2C_sda_in <= 1;
    check2 = 0;
    
    /* Verifying Address send after repeat start */
    @ (negedge I2C_sda)
    @ (posedge I2C_scl)
    data_store[7] = I2C_sda;
    @ (posedge I2C_scl)
    data_store[6] = I2C_sda;
    @ (posedge I2C_scl)
    data_store[5] = I2C_sda;
    @ (posedge I2C_scl)
    data_store[4] = I2C_sda;
    @ (posedge I2C_scl)
    data_store[3] = I2C_sda;
    @ (posedge I2C_scl)
    data_store[2] = I2C_sda;
    @ (posedge I2C_scl)
    data_store[1] = I2C_sda;
    @ (posedge I2C_scl)
    data_store[0] = I2C_sda;
    @ (negedge I2C_scl);
    if (data_store == data_send) begin
        I2C_sda_in <= 0;        
    end
    check1 = 1;
    
    /* Sending random data to the SPI over sda line */
    data_recieve = $random(r_seed);
    @ (negedge I2C_scl);
    check1 = 0;
    I2C_sda_in <= data_recieve[7];
    @ (negedge I2C_scl);
    I2C_sda_in <= data_recieve[6];
    @ (negedge I2C_scl);
    I2C_sda_in <= data_recieve[5];
    @ (negedge I2C_scl);
    I2C_sda_in <= data_recieve[4];
    @ (negedge I2C_scl);
    I2C_sda_in <= data_recieve[3];
    @ (negedge I2C_scl);
    I2C_sda_in <= data_recieve[2];
    @ (negedge I2C_scl);
    I2C_sda_in <= data_recieve[1];
    @ (negedge I2C_scl);
    I2C_sda_in <= data_recieve[0];
    @ (negedge I2C_scl);
    I2C_sda_in <= 1;
            
end


always @ (posedge I2C_scl) begin
    if (check1 & ~I2C_sda) begin
        $display("PASS: Address sending Verified",$time);
    end else if (check1) begin
        $display("Address sending Failed !",$time);
    end
    if (check2 & ~I2C_sda) begin
        $display("PASS: Data sending Verified",$time);
    end else if (check2) begin
        $display("Data sending Failed !",$time);
    end    
end

always @ (posedge SPI_sclk) begin
    if (check3 & (data_store == data_recieve))begin
        $display("PASS: Data receiving Verified",$time);
    end else if (check3)begin
        $display("Data receiving Failed !",$time);
    end
end
    
endmodule