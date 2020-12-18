// Code your testbench here
// or browse Examples
module HCF_test;
  
  reg [3:0] A,B;
  reg clk,clear,ready;
  wire [3:0] hcf;
  
  HCF hcf_1 (A,B,clk,ready,clear,hcf);
  
  initial
    begin
      
      #1
      ready=1;
      
      clear=1;
      
      #1
      clk=0;
      
      
      #2
      
      clear=0;
      A=8;
      B=12;
      
      
      #500
      $finish;
      
    end
  
  always
    begin
      #5
      clk=~clk;
    end
  
  initial
    begin
      $dumpfile("hcf.vcd");
      $dumpvars(0,HCF_test);
    end
  
  
  initial
    begin
      $monitor("time=%d hcf=%d",$time,hcf);
    end
  
endmodule

    
      
  
  
  