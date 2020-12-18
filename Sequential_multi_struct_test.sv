// Code your testbench here
// or browse Examples
module test_seq_mul;
  reg [3:0] A,B;
  reg Clk,Reset,ready;
  wire [7:0] Prod;
  
  Sequence_multi mul (A,B,Clk,Reset,ready,Prod);
                      
                      
                      initial
                        begin
                          
                          
                          #2
                          Clk=1'b0;
                          Reset=1'b1;
                          ready=1'b1;
                        end
                      
                      initial
                         begin
                           $dumpfile("seq_mul.vcd");
                           $dumpvars(0,test_seq_mul);
                           
                           #4
                           A=4'b1101;
                           B=4'b1011;
                           Reset=1'b0;
                           #200
                           $finish;
                     
                           
                         
                         end
                      
                      initial 
                        begin
                          $monitor(" time=%d product=%b ",$time,Prod);
                        end
                      
                      
                      always
                        begin
                          #5
                          Clk=~Clk;
                        end
                      
                     
                      
                      
endmodule
                      
                      
                      
                          
                      
                          
                     