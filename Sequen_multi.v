
module Sequen_multi(A,B,Clk,Reset,Prod,ready);
  input[3:0] A,B;
  input Reset,Clk,ready; // input ports
  output [7:0] Prod;  // output port
  
 
  
  
  
 
  parameter IDLE=3'b000,SHIFT=3'b001,ADD=3'b010,HALT=3'b011,DEC=3'b100;//parameters for present state
  
 //defining the variables of reg type 
  reg [3:0] Multiplicant,Multiplier;
  
  reg [3:0] Count,Sum;
  reg carry;
  
  reg [2:0] present,next;
  
  
  
  always@(posedge Clk)
    begin
     
         present=next;// flipflop for present state
      
    end
  
   
  
    
  always@(present or Count or Multiplier[0] or ready)//combinational logic to decide state and do operations
    begin
      
      if(ready==1) 
       begin
      
      case(present)
        IDLE : //initialises the registers
               begin
                 Multiplicant<=A;
                 Multiplier<=B;
                 carry<=0;
                 Sum<=0;
                 Count<=0;
                next<=ADD;
                 
                 
                 
               end
        		
        
        
        
        SHIFT : 
          
          if(Count!=4) //does right shift by 1 and goes to add state
                 begin
                  
                   Multiplier={Sum[0],Multiplier[3:1]};
                   Sum={carry,Sum[3:1]};
                    next=ADD;
                 end
        
              
        
                 
               
        
        else if(Count==4) //does right shift by 1 and goes to halt state
                  begin
                    Multiplier={Sum[0],Multiplier[3:1]};
                   Sum={carry,Sum[3:1]};
                    next=HALT;
                    
                  end
                   
                 
        
        ADD : 
        
            //addition is done and counter is incremented by 1
            
            if(Multiplier[0]==1)
            begin
              {carry,Sum}=Sum+Multiplicant;
              Count=Count+1;
              
              next=SHIFT;
              
            end
            
            else if(Multiplier[0]==0)
              begin
                carry=0;
                Count=Count+1;
              
              next=SHIFT;
              
              end
             
             
              
          
        // multiplication stops
        HALT : begin
               
               next=HALT;
               end
        
      
        
        default :next=IDLE;
        
        
      
        
        
      endcase   
        end
      
    end
  //final product is seen through Prod
  assign Prod={Sum,Multiplier};
  
endmodule
        
        
        