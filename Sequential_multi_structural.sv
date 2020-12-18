


module Sequence_multi(multiplicand,multiplier,clk,clear,ready,product);
  
  //input ports and output ports
  input [3:0] multiplicand,multiplier;
  input clk,clear,ready;
  output [7:0] product;
  
  //intermediate registers and wires
  reg load_A,load_B,shift_A,shift_B,inc; //control signals to control pipo register and counter
  wire [3:0] in2,B,Mul_out,sum;
  wire carry_o;
  wire cout;
  wire [3:0] counter_out;
  wire [3:0] mux_out;
  wire cin;
  
  //state register
  reg [3:0] present,next;
  
  parameter idle=2'b00,shift=2'b01,add=2'b10,halt=2'b11; //states
  
   
  
  assign cin=0;// carry in of adder initialised to zero
  assign in2=0;
  
  Dflip carry (cout,clk,clear,carry_o);  
  pipo_shift summ (sum,carry_o,load_A,shift_A,clk,clear,B); 
  pipo_shift mul (multiplier,B[0],load_B,shift_B,clk,clear,Mul_out); 

  counter count (inc,clear,clk,counter_out);
  Mux2_1 Mux1 (in2,multiplicand,Mul_out[0],mux_out); 
  Adder_4_bit addr1 (mux_out,B,cin,sum,cout);
    
 //state flipflop 
  always @(posedge clk)
      begin
        present<=next;
      end
    

  //control unit
  always@ (present or ready)
      begin
        
      
        
        case(present)
          
          idle : begin // load mul register with multiplier value
            
            if(ready==1)
              begin
                load_B=1;load_A=0;shift_A=0;shift_B=0;inc=0;
                
                next=add; // move to add state
              end
            else
              next=idle;
          end
            
           
          
          add: begin
            
            // summ register with multiplicand or 0 depending on Mul_out[0] value-> taken care by Mux1
             load_B=0;load_A=1;shift_A=0;shift_B=0;inc=1;
             next=shift; //move to shift state
             
           end
            
            
         
          
          shift: begin
            
            // shift 
            if(counter_out!=4) // multiplication not completed
              begin
                
               load_B=0;load_A=0;shift_A=1;shift_B=1;inc=0;
               next=add; //move to add state
              end
            
            
            else if(counter_out==4) // multiplication completed
              begin
                load_B=0;load_A=0;shift_A=1;shift_B=1;inc=0;
                next=halt; 
              end
          end
            
          halt: begin //end state
              
              load_B=0;load_A=0;shift_A=0;shift_B=0;inc=0;
              next=halt; // be in halt
              
            end
            
          default :next=idle; // default state is idle
        endcase
      end
  
  
  assign product={B,Mul_out};
    
  endmodule
            
            
//parallel input and parallel output right shift registers
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
// dflipflop
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
//4_bit counter
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

//4 bit 2x1Mux
module Mux2_1(in1,in2,sel,out);
  input [3:0] in1,in2;
  input sel;
  output [3:0] out;
  
  assign out=sel==0?in1:in2;
  
  
endmodule
//4 bit adder
module Adder_4_bit(A,B,cin,sum,cout);
  input [3:0] A,B;
  input cin;
  output [3:0] sum;
  output cout;
  
  assign {cout,sum}=A+B+cin;
  
endmodule           
             
                
              
              
             
    
  

      
            
