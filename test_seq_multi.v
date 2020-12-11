module test_seq_mul;
  reg [3:0] A,B;
  reg Clk,Reset,ready;
  wire [7:0] Prod;
  
  Sequen_multi mul (.A(A),.B(B),.Clk(Clk),.Reset(Reset),.Prod(Prod),.ready(ready));
                      
                      
                      initial
                        begin
                          #5
                          Clk=1'b0;
                          Reset=1'b0;
                          ready=1'b1;
                        end
                      
                      initial
                         begin
                           $dumpfile("seq_mul.vcd");
                           $dumpvars(0,test_seq_mul);
                           
                           #5
                           A=4'b1101;
                           B=4'b1011;
                           #200
                           $finish;
                     
                           
                         
                         end
                      
                      initial 
                        begin
                          $monitor(" time=%d product=%d ",$time,Prod);
                        end
                      
                      
                      always
                        begin
                          #5
                          Clk=~Clk;
                        end
                      
                     
                      
                      
endmodule
                      