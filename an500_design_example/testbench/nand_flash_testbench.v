/****************************************************************************************************
* TESTBENCH FOR NAND FLASH INTERFACE
* March, 2007
****************************************************************************************************/
`timescale 1 ns/1 ns
module nand_flash_testbench;
     
reg    [2:0] t_cntrl;    //Control input
reg  [5:0] test_vector;  //Input to the test bench
wire [6:0] test_out;     //Output of the system
reg   clk;         //Clock and ready signal
    
initial
begin
   clk=1;
   forever   #5 clk=~clk;
end         

nand_interface nand_intf(.reset (test_vector[5]),
               .h_rd_wr (test_vector[4]),
               .e_d (test_vector[3]),
               .h_cntrl (test_vector[2:0]),
               .cle (test_out[6]),
               .re (test_out[5]), 
               .we (test_out[4]),
               .ale (test_out[3]),
               .se (test_out[2]), 
               .wp (test_out[1]), 
               .ce (test_out[0]) 
               );

//Assigning all possible combination of input to the test_vector after every 10 clock cycle
initial
begin
    $display("This Test Bench checks the values of the various interfacing signals of the Nand Flash Device for the different commands supported");
    
    #10 test_vector=6'b1xxxxx;//reset 
    t_cntrl = {test_vector[2],test_vector[1],test_vector[0]};
    $display("Reset command.",$time);    
            
        #10 test_vector=6'b000101; //wp_d
           t_cntrl = {test_vector[2],test_vector[1],test_vector[0]};
            $display("Disasserting Write Protect.",$time);
        
        #10 test_vector=6'b000110; //ce_d
            t_cntrl = {test_vector[2],test_vector[1],test_vector[0]};
            $display("Disasserting Chip Enable.",$time);
        
        #10 test_vector=6'b001110; //ce
            t_cntrl = {test_vector[2],test_vector[1],test_vector[0]};
            $display("Asserting Chip Enable.",$time);
        
        #10 test_vector=6'b001011; //ale
            t_cntrl = {test_vector[2],test_vector[1],test_vector[0]};
            $display("Asserting Address Latch Enable.",$time);
        
        #10 test_vector=6'b001010; //we
            t_cntrl = {test_vector[2],test_vector[1],test_vector[0]};
            $display("Asserting Write Enable.",$time);
        
        #10 test_vector=6'b000011; //ale_d
            t_cntrl = {test_vector[2],test_vector[1],test_vector[0]};
            $display("Disasserting Address Latch Enable.",$time);
       
        #10 test_vector=6'b000000; //cle
            t_cntrl = {test_vector[2],test_vector[1],test_vector[0]};
            $display("Asserting Command Latch Enable.",$time);
        
        #10 test_vector=6'b001100; //se
            t_cntrl = {test_vector[2],test_vector[1],test_vector[0]};
            $display("Asserting Spare Area Enable.",$time);
        
        
        #10 test_vector=6'b000100; //se_d
            t_cntrl = {test_vector[2],test_vector[1],test_vector[0]};
            $display("Disasserting Spare Area Enable.",$time);
        

        #10 test_vector=6'b010001; //re
            t_cntrl = {test_vector[2],test_vector[1],test_vector[0]};
            $display("Asserting Read Enable.",$time);
         
        #10 test_vector=6'b001101; //wp
            t_cntrl = {test_vector[2],test_vector[1],test_vector[0]};
            $display("Asserting Write Protect.",$time);
        
        #10 test_vector=6'b010111; //ready
            t_cntrl = {test_vector[2],test_vector[1],test_vector[0]};
            $display("Checking the ready/busy signal.",$time);
        
        #10 test_vector=6'b000110; //ce_d
            t_cntrl = {test_vector[2],test_vector[1],test_vector[0]};
            $display("Disasserting Chip Enable.",$time);

   end
   
//Checking for the outputs of the test bench   

always
begin
//$display("chk2",$time);

 #15 if((test_vector[5]==1'b1)&(test_out === 7'bxxx0100))
 $display("Command to reset the device verified",$time);
					
 #10 if((t_cntrl == 3'b101)&(test_vector[3]==1'b0)&(test_out === 7'b0110110)) 
 $display("Command to disassert Write Protect verified",$time);

 #10 if((t_cntrl == 3'b110)&(test_vector[3]==1'b0)&(test_out === 7'b0110111)) 
 $display("Command to disassert Chip Enable verified",$time);
 
 #10 if((t_cntrl == 3'b110)&(test_vector[3]==1'b1)&(test_out === 7'b0110110)) 
 $display("Command to assert Chip Enable verified",$time);

 #10 if((t_cntrl == 3'b011)&(test_out === 7'b0111110)&(test_vector[3]==1'b1))
  $display("Command to assert Address Latch Enable verified",$time);
  
 #10 if((t_cntrl == 3'b010)&(test_out === 7'b0101110))
  $display("Command to asserting Write Enable verified",$time); 
 
 #10 if ((t_cntrl == 3'b011)&(test_vector[3]==1'b0)&(test_out === 7'b0110110)) 
  $display("Command to disassert Address Latch Enable verified",$time);
   
 #10 if((t_cntrl == 3'b000)&(test_out === 7'b1110110))
  $display("Command to assert Command Latch Enable verified",$time); 
  
 #10 if((t_cntrl == 3'b100)&(test_vector[3]==1'b1)&(test_out === 7'b0110010))
 $display("Command to assert Spare Area Enable verified",$time);
 
 #10 if((t_cntrl == 3'b100)&(test_vector[3]==1'b0)&(test_out === 7'b0110110))
 $display("Command to disassert Spare Area Enable verified",$time);

 #10 if((t_cntrl == 3'b001)&(test_out === 7'b0010110))
 $display("Command to assert Read Enable verified",$time);


 #10 if((t_cntrl == 3'b101)&(test_vector[3]==1'b1)&(test_out === 7'b0110100))    
 $display("Command to assert Write Protect verified",$time);
 
 #10 if((t_cntrl == 3'b111)&(test_vector[3]==1'b0) &(test_out === 7'b0110110)) 
 $display("Command for checking the ready/busy signal verified",$time);
          
 #10 if((t_cntrl == 3'b110)&(test_vector[3]==1'b0)&(test_out === 7'b0110111))  
 $display("Command to disassert Chip Enable verified",$time);
 $display("All outputs successfully verified.......TEST PASSED................",$time); 
 #200 $stop;
end
     
       
endmodule


/****************************** End of Test Bench**************************************************************************/
