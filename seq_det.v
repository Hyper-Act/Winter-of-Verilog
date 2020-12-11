module sequence_detector(rst,clk,ip,op);            // verilog code for 101101 seq detector //

	output reg op;
 	input clk, rst, ip;

	 reg [2:0] state;
	 reg [2:0] next_state;

	 parameter [2:0] s0=3'b000;
	 parameter [2:0] s1=3'b001;
	 parameter [2:0] s2=3'b010;
	 parameter [2:0] s3=3'b011;
	 parameter [2:0] s4=3'b100;
	 parameter [2:0] s5=3'b101;

	 always @(posedge clk, posedge rst)
	 begin
		if (rst)
   			state=s0;                      // ground state //
  		else
   			state=next_state;             // on clk count moving to next state //
	 end

	 always @(state, next_state)                  // when state changes //
	 begin
	 	case(state)
		s0:
			if (ip)                       // moving to next state is dependent on present state and input //
   			begin
    				next_state=s1;
    				op=1'b0;
   			end
   			else
   			begin
    				next_state=s0;
    				op=1'b0;
   			end
  		s1:
   			if (ip)
   			begin
    				next_state=s1;
    				op=1'b0;
   			end
   			else
   			begin
    				next_state=s2;
    				op=1'b0;
   			end
  		s2:
   			if (ip)
   			begin
    				next_state=s3;
    				op=1'b0;
   			end
   			else
   			begin
    				next_state=s0;
    				op=1'b0;
   			end
  		s3:
   			if (ip)
   			begin
    				next_state=s4;
    				op=1'b0;
   			end
   			else
   			begin
    				next_state=s2;
    				op=1'b0;
   			end
  		s4:
   			if (ip)
   			begin 
    				next_state=s1;
    				op=1'b0;
   			end
   			else
   			begin
    				next_state=s5;
    				op=1'b0;
   			end 
  		s5:
   			if (ip)                               // if state =5 and input = 1 then our sequence is deteceted //
   			begin
    				next_state=s1;               //  hence output is 1 //
    				op=1'b1;
   			end
   			else
   			begin
    				next_state=s0;
   				op=1'b0;
   			end
  		default:                                      // default case gets us to ground state //
   			begin
           			next_state=s0;
           			op=1'b0;
   			end
  		endcase
 	end
endmodule