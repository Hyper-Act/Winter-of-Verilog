// Code your design here

// Parallel in parellel out register
module pipo(Load_in,load,clk,clear,out);
  input [3:0] Load_in;
  input clk,clear,load;
  output [3:0] out;
  reg [3:0] out;
  
  always@(posedge clk or posedge clear)
    begin
      
    if(clear==1)
      out<=0;
    
    else if(load==1)
      out<=Load_in;
 
    else
        out<=out;
    end
  
endmodule


// Subtractor
module Subtract_4_bit(A,B,cin,sum,cout);
  input [3:0] A,B;
  input cin;
  output [3:0] sum;
  output cout;
  
  assign {cout,sum}=A-B;
  
endmodule  



// 4 bit comparator
module comparator(A,B,G,L,E);
  input [3:0] A,B;
  output G,L,E;
  
  assign G=(A>B)?1:0;
  assign L=(A<B)?1:0;
  assign E=(A==B)?1:0;
  
endmodule


//4_bit 2x1Mux
module Mux2_1(in1,in2,sel,out);
  input [3:0] in1,in2;
  input sel;
  output [3:0] out;
  
  
  assign #1 out=sel==0?in1:in2;
  
  
endmodule


//Top module to find HCF
module HCF(A,B,clk,ready,clear,hcf);
 
  //Input and output ports
  input [3:0] A,B;
  input clk,ready,clear;
  output [3:0] hcf;
  
  
  //all intermediate wires connections
  reg load_A,load_B,sel_input,sel_s1;//main control signals
  wire [3:0] A_mux_o,B_mux_o;// outputs of muxA and muxB connected to A_reg and B_reg
  wire [3:0] A_out,B_out;// pipo register A_reg and B_reg outputs
  wire [3:0] Sub_A,Sub_B;// outputs of mux connected to subtractor
  
  wire G,L,E;// comparator outputs
  wire [3:0] sub;// subtractor output given to A_reg or B_reg using common bus
  wire sel_s2;// select line of mux2 connected to subractor input 2
  wire cin;// carryin to subtractor
  wire cout;// carryout of subtractor
  wire A_0,B_0;// variables to store zero flag
  
  reg [3:0] present,next;//variables to represent next and present state
  
  parameter read=3'b000,comp=3'b001,Subtract_A=3'b010,Subtract_B=3'b011,halt=3'b100;//states
  
  assign sel_s2=~sel_s1;// assigning s2 invereted of s1 select line
  assign cin=1;
  
  assign A_0=A_out==0?1:0;//zero flag for A_reg
  assign B_0=B_out==0?1:0;// zero flag for B_reg
  
  
  
 
  

  Mux2_1 Mux_A (A,sub,sel_input,A_mux_o); //mux connected to A_reg input
  Mux2_1 Mux_B (B,sub,sel_input,B_mux_o); //mux connected to B_reg input
  pipo A_reg (A_mux_o,load_A,clk,clear,A_out);//A_register
  pipo B_reg (B_mux_o,load_B,clk,clear,B_out);//B_register
  
 
 
  
  comparator compare (A_out,B_out,G,L,E);//Comparator
  
  Mux2_1 Mux_S1(A_out,B_out,sel_s1,Sub_A);//Mux connected to subractor input 1
  Mux2_1 Mux_S2(A_out,B_out,sel_s2,Sub_B);//Mux connected to subtractor input 2
  Subtract_4_bit Sub_1 (Sub_A,Sub_B,cin,sub,cout);// Subtractor
  
 
  //Flipflops to assign next state to present state
  always@(posedge clk or posedge clear)
    begin
      if(clear==1)
        present<=0;
      
      else if(clear==0)
        present<=next;
    end
  
  
  
  //combinational logic to assign control signals and find next state
  always@(present )
    begin
      case(present)
        
        read:// load inputs A and B in registers
          begin
            if(ready==1)
            begin

              load_A=1;load_B=1;sel_input=0;sel_s1=0;
              next=comp;
            end

            else if(ready==0)
              next=read;
          end
        
        
        
        comp://Compare values of A and B
          begin
            
            
            
            if(A_0==1) // check if A value is zero
              begin
                
                load_A=0;load_B=0;
                next=halt;
              end
            
                
              
            else if(B_0==1) // check if B values is zero
              begin
               
                load_A=0;load_B=0;
                next=halt;
              end
            
            else if(E==1)// check if A=B
              begin
                
                load_A=0;load_B=0;
                next=halt;
              end
                
              
            
           
            
            
          
              
              
            else if(G==1) //check if A>B
              begin
                
               
                load_A=0;load_B=0;
                next=Subtract_A;
              end
            
            else if(L==1) // check if A<B
              begin
               
                load_A=0;load_B=0;
                next=Subtract_B;
              end
              
              
            
          end
        
        Subtract_A: //A=A-B
          begin
            load_A=1;load_B=0;sel_input=1;sel_s1=0;
            next=comp;
          end
        
        Subtract_B://B=B-A
          begin
            load_A=0;load_B=1;sel_input=1;sel_s1=1;
            next=comp;
          end
        
        halt:
          begin //END state
            load_A=0;load_B=0;
            next=halt;
          end
        
        
     
        
      endcase
    end
  
  
  
  assign hcf=(E==1)?A_out:0;//Assigning HCf combinational logic 
              
        
        
  
  
endmodule
  