


module Sequence_multi(multiplicand,multiplier,clk,clear,ready,product);
  
  input [3:0] multiplicand,multiplier;
  input clk,clear,ready;
  output [7:0] product;
  reg load_A,load_B,shift_A,shift_B,inc;
  wire [3:0] in2,B,Mul_out,sum;
  wire carry_o;
  wire cout;
  
 
  wire [3:0] counter_out;
  wire [3:0] mux_out;
  wire cin;
  
  
  reg [3:0] present,next;
  
  parameter idle=2'b00,shift=2'b01,add=2'b10,halt=2'b11;
  
   
  
  assign cin=0;
  assign in2=0;
  
  Dflip carry (cout,clk,clear,carry_o);  
  pipo_shift summ (sum,carry_o,load_A,shift_A,clk,clear,B); 
  pipo_shift mul (multiplier,B[0],load_B,shift_B,clk,clear,Mul_out); 

  counter count (inc,clear,clk,counter_out);
  Mux2_1 Mux1 (in2,multiplicand,Mul_out[0],mux_out); 
  Adder_4_bit addr1 (mux_out,B,cin,sum,cout);
    
  
  always @(posedge clk)
      begin
        present<=next;
      end
    
  always@ (present or ready)
      begin
        
      
        
        case(present)
          
          idle : begin
            
            if(ready==1)
              begin
                load_B=1;load_A=0;shift_A=0;shift_B=0;inc=0;
                
                next=add;
              end
            else
              next=idle;
          end
            
           
          
          add: begin
            
             
             load_B=0;load_A=1;shift_A=0;shift_B=0;inc=1;
             next=shift;
             
           end
            
            
         
          
          shift: begin
            
            
            if(counter_out!=4)
              begin
                
               load_B=0;load_A=0;shift_A=1;shift_B=1;inc=0;
               next=add;
              end
            
            
            else if(counter_out==4)
              begin
                load_B=0;load_A=0;shift_A=1;shift_B=1;inc=0;
                next=halt;
              end
          end
            
            halt: begin
              
              load_B=0;load_A=0;shift_A=0;shift_B=0;inc=0;
              next=halt;
              
            end
            
          default :next=idle;
        endcase
      end
  
  
  assign product={B,Mul_out};
    
  endmodule
            
            

module pipo_shift(Load_in,R_shift_in,load,shift,clk,clear,out);
  input [3:0] Load_in;
  input R_shift_in,clk,clear,load,shift;
  output [3:0] out;
  reg [3:0] out;
  
  always@(posedge clk or posedge clear)
    begin
      
    if(clear==1)
      out<=0;
    
    else if(load==1)
      out<=Load_in;
  
    else if(shift==1)
      out<={R_shift_in,out[3:1]};
      
      else
        out<=out;
    end
  
endmodule

module Dflip(in,clk,clear,out);
  
  input in,clk,clear;
  output out;
  reg out;
  always@(posedge clk or posedge clear)
    begin
      if(clear==1)
        out<=0;
      
      else if(clear==0)
        out<=in;
    end
endmodule

module counter(inc,clear,clk,out);
  
  input inc,clear,clk;
  output [3:0] out;
  reg [3:0] out;
  
  always@(posedge clk or posedge clear)
    begin
      if(clear==1)
        out<=0;
      else if(inc==1)
        out<=out+1;
      else
        out<=out;
    end
endmodule


module Mux2_1(in1,in2,sel,out);
  input [3:0] in1,in2;
  input sel;
  output [3:0] out;
  
  assign out=sel==0?in1:in2;
  
  
endmodule

module Adder_4_bit(A,B,cin,sum,cout);
  input [3:0] A,B;
  input cin;
  output [3:0] sum;
  output cout;
  
  assign {cout,sum}=A+B+cin;
  
endmodule           
             
                
              
              
             
    
  

      
            